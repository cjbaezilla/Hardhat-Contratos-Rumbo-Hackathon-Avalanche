# Guía Completa: Mecánica de DAOs con OpenZeppelin Governor

Esta guía te ayudará a entender cómo funciona realmente un sistema de governance on-chain usando los contratos de OpenZeppelin. Si eres nuevo en esto, léela completa antes de implementar nada.

## ¿Qué problema resuelve esto?

Imagina que tienes un protocolo descentralizado con una tesorería de millones de dólares. ¿Quién decide cómo se gastan? ¿Quién aprueba upgrades? ¿Quién cambia parámetros críticos?

La respuesta: un sistema de governance on-chain donde los holders de tokens votan propuestas que se ejecutan automáticamente si pasan.

## Arquitectura: Los 3 Pilares

Un sistema de governance necesita 3 contratos trabajando juntos:

```
┌─────────────────┐
│  Voting Token   │ ← Define QUIÉN puede votar y con CUÁNTO poder
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│    Governor     │ ← Gestiona propuestas, votos, y ejecución
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│    Timelock     │ ← Delay de seguridad antes de ejecutar (opcional)
└─────────────────┘
```

### 1. Token de Votación (ERC20Votes o ERC721Votes)

**Responsabilidad**: Llevar registro histórico del poder de voto de cada cuenta.

**¿Por qué no usar un ERC20 normal?**  
Porque necesitas saber cuántos tokens tenía alguien en un momento específico del pasado. Si usas el balance actual, alguien podría:
1. Votar en una propuesta
2. Transferir tokens a otra wallet
3. Votar otra vez con la misma wallet

El contrato `ERC20Votes` mantiene snapshots históricos usando checkpoints. Cada vez que se transfieren tokens, se guarda un checkpoint.

**Conceptos clave:**

- **Delegates**: El poder de voto no se activa automáticamente. Los holders deben "delegar" su poder de voto (pueden delegarse a sí mismos o a otro address).
- **Checkpoints**: Histórico de balances por block number o timestamp.
- **getPastVotes()**: Función que el Governor usa para saber cuántos votos tenía alguien en un momento específico.

```solidity
// El token debe implementar esto:
contract MyToken is ERC20, ERC20Votes {
    // Cuando un holder delega su voto:
    function delegate(address delegatee) public;
    
    // El Governor consulta esto:
    function getPastVotes(address account, uint256 timepoint) public view returns (uint256);
}
```

### 2. Governor (El cerebro del sistema)

**Responsabilidad**: Gestionar todo el ciclo de vida de las propuestas.

Este es el contrato más complejo. OpenZeppelin lo diseñó modular, así que seleccionas módulos según tus necesidades:

#### Módulos principales:

**Governor (core)** - Funcionalidad base
- Crear propuestas
- Estados de propuestas (Pending → Active → Succeeded/Defeated → Queued → Executed)
- Configuración de delays y períodos

**GovernorVotes** - Conexión con el token
- Se conecta al token ERC20Votes/ERC721Votes
- Consulta el poder de voto de los usuarios
- Detecta automáticamente si el token usa block numbers o timestamps

**GovernorCountingSimple** - Sistema de conteo de votos
- Opciones: For (a favor), Against (en contra), Abstain (abstención)
- Solo For y Abstain cuentan para el quorum
- Against no cuenta para quorum pero puede derrotar una propuesta

**GovernorVotesQuorumFraction** - Requisito de quorum
- Define el % de supply total necesario para que una propuesta sea válida
- Ejemplo: 4% significa que al menos el 4% del supply total debe votar
- Se calcula sobre el supply al momento que la propuesta se crea

**GovernorTimelockControl** - Integración con Timelock (opcional)
- Si usas timelock, este módulo conecta el Governor con el TimelockController
- Cambia el flujo: después de que una propuesta pasa, va a una "cola" con delay antes de ejecutarse

#### Parámetros críticos del Governor:

```solidity
function votingDelay() public pure returns (uint256) {
    return 1 days; // Tiempo entre crear propuesta y poder votar
}

function votingPeriod() public pure returns (uint256) {
    return 1 weeks; // Duración del período de votación
}

function proposalThreshold() public pure returns (uint256) {
    return 1000e18; // Tokens mínimos para crear propuesta (0 = cualquiera puede)
}
```

**¿Por qué existe votingDelay?**  
Para evitar ataques flash loan. Si creas una propuesta y se puede votar inmediatamente, alguien podría:
1. Pedir prestado millones de tokens con flash loan
2. Crear y votar una propuesta maliciosa
3. Devolver los tokens en la misma transacción

Con un delay de 1 día, el snapshot del poder de voto se toma antes de que sepas qué se va a proponer, haciendo imposible este ataque.

### 3. Timelock (El guardián de seguridad)

**Responsabilidad**: Agregar un delay entre aprobar y ejecutar propuestas.

Este es un contrato separado (TimelockController) que actúa como intermediario:

```
Propuesta aprobada → Queue en Timelock (48h delay) → Ejecución
```

**¿Por qué usarlo?**  
Da tiempo a los usuarios para reaccionar:
- Si pasa una propuesta maliciosa, los usuarios tienen 48h para salir del protocolo
- Los holders pueden unstakear sus tokens
- La comunidad puede organizarse para detener algo sospechoso

**Roles del Timelock:**

```solidity
// Quién puede hacer queue de propuestas aprobadas
PROPOSER_ROLE → Governor contract (solo él)

// Quién puede ejecutar propuestas después del delay
EXECUTOR_ROLE → address(0) (cualquiera puede ejecutar)
               → O el Governor (si quieres más control)

// Admin que puede modificar roles
ADMIN_ROLE → El propio Timelock (self-governed)
           → Opcionalmente tu address al desplegar (renuncia después)
```

**IMPORTANTE**: Cuando usas Timelock, **es el Timelock quien ejecuta las propuestas**, no el Governor. Esto significa:
- Los fondos deben estar en el Timelock
- Los roles de admin deben estar en el Timelock
- La ownership de contratos debe estar en el Timelock

## Flujo Completo: Ciclo de Vida de una Propuesta

Aquí está TODO el proceso paso a paso:

### Paso 0: Preparación (Solo una vez)

```javascript
// Los holders deben delegar su voto (a sí mismos o a alguien más)
await token.delegate(myAddress); // Self-delegate

// Esto activa su poder de voto. Sin esto, aunque tengas tokens, no puedes votar.
```

### Paso 1: Crear Propuesta

Cualquier holder (que cumpla el threshold) puede crear una propuesta:

```javascript
const targets = [tokenAddress]; // Contratos a llamar
const values = [0]; // ETH a enviar (0 si no enviamos ETH)
const calldatas = [transferCalldata]; // Función a ejecutar (encoded)
const description = "Proposal #1: Grant 10,000 tokens to dev team";

await governor.propose(targets, values, calldatas, description);
```

**Datos de la propuesta:**
- `targets[]` - Array de addresses de contratos a llamar
- `values[]` - Array de cantidades de ETH a enviar (en wei)
- `calldatas[]` - Array de function calls codificadas
- `description` - Texto legible para humanos

**¿Por qué arrays?**  
Porque una propuesta puede ejecutar múltiples acciones:

```javascript
// Propuesta que hace 3 cosas:
targets = [tokenContract, nftContract, treasuryContract]
values = [0, 0, ethers.utils.parseEther("10")] // Solo envía 10 ETH en la 3ra
calldatas = [
    token.interface.encodeFunctionData('mint', [user, amount]),
    nft.interface.encodeFunctionData('setBaseURI', [newUri]),
    treasury.interface.encodeFunctionData('release', [])
]
```

**Estado después de crear**: `Pending`

### Paso 2: Voting Delay (Automático)

El contrato espera el `votingDelay` configurado (ej: 1 día = 7200 blocks).

Durante este tiempo:
- El Governor toma un snapshot del poder de voto de todos
- La propuesta está "congelada" en estado Pending
- Nadie puede votar todavía

**Estado después del delay**: `Active`

### Paso 3: Período de Votación

Los holders pueden votar durante el `votingPeriod` (ej: 1 semana).

```javascript
// Opción 0 = Against, 1 = For, 2 = Abstain
await governor.castVote(proposalId, 1); // Voto a favor

// Con razón:
await governor.castVoteWithReason(proposalId, 1, "This is needed for X reason");

// Con firma (permite votar sin gas):
await governor.castVoteBySig(proposalId, support, v, r, s);
```

**Reglas de votación:**
- Cada address vota con el poder que tenía en el snapshot (no el balance actual)
- Solo puedes votar una vez
- No puedes cambiar tu voto después
- Abstenciones cuentan para quorum pero no afectan el resultado

**¿Cuándo pasa una propuesta?**
1. Se alcanza el quorum (ej: 4% del supply votó)
2. Hay más votos "For" que "Against"

**Estados posibles después del período:**
- `Succeeded` - Pasó (tiene quorum y más For que Against)
- `Defeated` - No pasó (no tiene quorum O más Against que For)

### Paso 4: Queue (Solo si usas Timelock)

Si la propuesta pasó Y usas timelock, debes hacer queue manualmente:

```javascript
const descriptionHash = ethers.utils.id(description);

await governor.queue(
    targets,
    values,
    calldatas,
    descriptionHash // Solo el hash, no el texto completo
);
```

Esto mueve la propuesta al Timelock con un delay (ej: 48 horas).

**Estado después de queue**: `Queued`

**¿Por qué pasar todos los parámetros otra vez?**  
El Governor NO guarda los datos de la propuesta on-chain (para ahorrar gas). Solo guarda el hash. Por eso debes pasar todo de nuevo para que el contrato verifique que coincide con el hash guardado.

Los parámetros siempre están disponibles en los eventos que emitió el contrato.

### Paso 5: Espera del Timelock (Automático)

El Timelock espera su `minDelay` configurado (ej: 48 horas).

Durante este tiempo:
- La operación está "programada" pero no se puede ejecutar
- Los usuarios pueden ver exactamente qué se va a ejecutar
- La comunidad puede reaccionar si algo está mal

### Paso 6: Ejecución

Después del delay del timelock (o inmediatamente si no usas timelock), cualquiera puede ejecutar:

```javascript
await governor.execute(
    targets,
    values,
    calldatas,
    descriptionHash
);
```

**Esto ejecuta todas las acciones de la propuesta:**
- Llama a cada contrato en `targets[]`
- Con los calldatas correspondientes
- Enviando el ETH especificado en `values[]`

**Estado después de ejecutar**: `Executed`

**CRÍTICO**: Si usas Timelock, las llamadas salen del Timelock, no del Governor. Por eso el Timelock debe tener los permisos y fondos necesarios.

## Interacciones Entre Contratos

Aquí está quién llama a quién en cada paso:

### Durante creación de propuesta:
```
Usuario → Governor.propose()
    ↓
Governor → Token.getPastVotes(proposer, snapshot)
    (verifica que el proposer tenga suficientes votos)
```

### Durante votación:
```
Usuario → Governor.castVote(proposalId, support)
    ↓
Governor → Token.getPastVotes(voter, snapshot)
    (obtiene el peso del voto)
    ↓
Governor actualiza contadores internos
```

### Durante queue (con Timelock):
```
Usuario → Governor.queue(...)
    ↓
Governor → Timelock.schedule(...)
    (programa la ejecución)
```

### Durante ejecución (con Timelock):
```
Usuario → Governor.execute(...)
    ↓
Governor → Timelock.execute(...)
    ↓
Timelock → Target Contract(s)
    (ejecuta las acciones reales)
```

### Durante ejecución (sin Timelock):
```
Usuario → Governor.execute(...)
    ↓
Governor → Target Contract(s)
    (ejecuta directamente)
```

## Errores Comunes y Cómo Evitarlos

### 1. "No voting power"
**Problema**: Tienes tokens pero no puedes votar.  
**Solución**: Debes llamar a `token.delegate(myAddress)` para activar tu poder de voto.

### 2. "Governor: vote not currently active"
**Problema**: Intentas votar pero la propuesta no está activa.  
**Solución**: Espera a que pase el `votingDelay` después de que se creó la propuesta.

### 3. "Governor: proposal not successful"
**Problema**: Intentas hacer queue/execute de una propuesta que no pasó.  
**Solución**: Verifica que tenga quorum Y más votos For que Against.

### 4. "TimelockController: operation is not ready"
**Problema**: Intentas ejecutar antes de que pase el delay del timelock.  
**Solución**: Espera el `minDelay` configurado después de hacer queue.

### 5. Fondos están en el Governor pero no se pueden usar
**Problema**: Cuando usas Timelock, los fondos deben estar en el Timelock, no en el Governor.  
**Solución**: Transfiere todos los fondos y roles al Timelock.

### 6. La propuesta se ejecuta pero falla
**Problema**: El target contract reversa la transacción.  
**Solución**: Verifica que el Timelock (o Governor) tenga los permisos necesarios en el target contract.

## Block Numbers vs Timestamps

OpenZeppelin soporta dos modos de operación:

### Modo Block Numbers (default)
- `votingDelay = 7200` → 7200 blocks (≈1 día si 12 seg/block)
- `votingPeriod = 50400` → 50400 blocks (≈1 semana)
- Usa checkpoints por número de block
- Funciona en todas las redes

### Modo Timestamps (desde v4.9)
- `votingDelay = 1 days` → 86400 segundos
- `votingPeriod = 1 weeks` → 604800 segundos
- Usa checkpoints por timestamp
- Mejor para L2s con tiempos de block impredecibles

**Para cambiar a timestamps**, override en tu token:

```solidity
contract MyToken is ERC20, ERC20Votes {
    function clock() public view override returns (uint48) {
        return uint48(block.timestamp);
    }

    function CLOCK_MODE() public pure override returns (string memory) {
        return "mode=timestamp";
    }
}
```

El Governor detecta automáticamente el modo del token. No necesitas hacer nada más.

## Configuración Recomendada para Producción

```solidity
// Token
ERC20Votes con timestamps (mejor para L2)

// Governor
votingDelay = 1 day (previene ataques flash loan)
votingPeriod = 1 week (suficiente tiempo para votar)
proposalThreshold = 0.1% of supply (evita spam)
quorum = 4% of supply (estándar en la industria)

// Timelock
minDelay = 2 days (da tiempo de reaccionar)
PROPOSER_ROLE = Governor contract
EXECUTOR_ROLE = address(0) (cualquiera puede ejecutar)
```

## Recursos Útiles

- **OpenZeppelin Wizard**: https://wizard.openzeppelin.com/#governor
- **Tally**: https://www.tally.xyz (UI para governance)
- **Defender**: Para crear propuestas sin código

## Ejemplo Mínimo Completo

Token:
```solidity
contract MyToken is ERC20, ERC20Votes {
    constructor() ERC20("MyToken", "MTK") ERC20Permit("MyToken") {
        _mint(msg.sender, 1000000e18);
    }
}
```

Governor:
```solidity
contract MyGovernor is 
    Governor,
    GovernorVotes,
    GovernorVotesQuorumFraction,
    GovernorTimelockControl 
{
    constructor(IVotes _token, TimelockController _timelock)
        Governor("MyGovernor")
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(4)
        GovernorTimelockControl(_timelock)
    {}

    function votingDelay() public pure override returns (uint256) {
        return 1 days;
    }

    function votingPeriod() public pure override returns (uint256) {
        return 1 weeks;
    }
}
```

Timelock:
```solidity
TimelockController timelock = new TimelockController(
    2 days,              // minDelay
    [address(governor)], // proposers
    [address(0)],        // executors (0 = anyone)
    msg.sender           // admin (renounce later!)
);
```

Eso es todo. Con estos 3 contratos tienes un DAO funcional.
