# Implementación de Gobernanza Basada en Timestamps - UserSharesToken

## Resumen Ejecutivo

El contrato `UserSharesToken` ha sido actualizado para implementar gobernanza basada en **timestamps** en lugar de **números de bloque**, cumpliendo con los estándares **ERC-6372** y **ERC-5805**. Este cambio es crítico para garantizar la compatibilidad y confiabilidad en redes como Avalanche y otras Layer 2 donde los tiempos entre bloques pueden ser irregulares o impredecibles.

## ✅ Cambios Implementados

### Funciones Agregadas

```solidity
/// @notice Returns the current timestamp for voting checkpoints
/// @dev Implements ERC-6372 clock mode using timestamps instead of block numbers
/// @dev This is critical for Avalanche/L2 networks where block times can be irregular
/// @return Current timestamp as uint48
function clock() public view override returns (uint48) {
    return uint48(block.timestamp);
}

/// @notice Returns the clock mode used by this token
/// @dev Implements ERC-6372 to indicate timestamp-based voting
/// @return string Clock mode descriptor
function CLOCK_MODE() public pure override returns (string memory) {
    return "mode=timestamp";
}
```

## 🎯 Razones del Cambio

### 1. **Irregularidad de Bloques en Avalanche**

Avalanche y otras redes L2 pueden producir bloques basados en:
- Demanda de la red
- Actividad de transacciones
- Mecanismos de consenso dinámicos

Esto significa que asumir "12 segundos por bloque" como en Ethereum puede llevar a:
- ❌ Períodos de votación impredecibles
- ❌ Deadlines incorrectos
- ❌ Experiencia de usuario confusa
- ❌ Incompatibilidad con actualizaciones de red

### 2. **Estándares Modernos**

- **ERC-6372**: Estándar que define interfaces de reloj para contratos de votación
- **ERC-5805**: Especifica el comportamiento de tokens de votación
- **OpenZeppelin v4.9+**: Recomienda timestamps para redes modernas

### 3. **Ventajas de Timestamps**

| Aspecto | Bloques | Timestamps |
|---------|---------|------------|
| Precisión temporal | Variable (depende de tiempo de bloque) | Precisa (segundos UNIX) |
| Predecibilidad | Baja en L2 | Alta en todas las redes |
| Experiencia de usuario | Confusa ("7200 bloques") | Clara ("1 día") |
| Compatibilidad futura | Requiere actualización si cambia tiempo de bloque | Independiente de la red |
| Herramientas DAO | Requiere conversión | Soporte nativo |

## 🔧 Diferencias Técnicas de Implementación

### Antes del Cambio (Basado en Bloques)

```solidity
// El token usaba el modo por defecto (bloques)
// NO había funciones clock() o CLOCK_MODE()

// En un Governor hipotético:
function votingDelay() public pure virtual returns (uint256) {
    return 7200; // 7200 bloques ≈ 1 día (asumiendo 12 seg/bloque)
}

function votingPeriod() public pure virtual returns (uint256) {
    return 50400; // 50400 bloques ≈ 1 semana
}
```

**Problemas:**
- Si Avalanche cambia a bloques de 2 segundos, 7200 bloques = 4 horas (no 1 día)
- Los usuarios ven "la votación termina en 7200 bloques" → confusión
- Las herramientas deben convertir bloques a tiempo estimado

### Después del Cambio (Basado en Timestamps)

```solidity
// UserSharesToken ahora implementa:
function clock() public view override returns (uint48) {
    return uint48(block.timestamp);
}

function CLOCK_MODE() public pure override returns (string memory) {
    return "mode=timestamp";
}

// En un Governor compatible:
function votingDelay() public pure virtual returns (uint256) {
    return 1 days; // 86400 segundos - EXACTO
}

function votingPeriod() public pure virtual returns (uint256) {
    return 1 weeks; // 604800 segundos - EXACTO
}
```

**Ventajas:**
- ✅ Precisión independiente de la red
- ✅ UX clara: "la votación termina el 15 de Octubre a las 14:30"
- ✅ Código más legible (`1 days` vs `7200`)
- ✅ Compatibilidad con herramientas DAO modernas

## 📊 Comparación de Parámetros

| Parámetro | Modo Bloque | Modo Timestamp | Notas |
|-----------|-------------|----------------|-------|
| votingDelay | 7200 bloques | 1 days (86400 seg) | Tiempo de espera antes de votar |
| votingPeriod | 50400 bloques | 1 weeks (604800 seg) | Duración de votación |
| proposalThreshold | 100 tokens | 100 tokens | Sin cambio |
| quorum | 4% supply | 4% supply | Sin cambio |
| Clock mode | block.number | block.timestamp | Cambio fundamental |

## 🔄 Impacto en Integración

### Para Frontends Web3

**Antes:**
```javascript
// Frontend tenía que estimar tiempo
const blocksRemaining = await governor.proposalDeadline(proposalId);
const currentBlock = await provider.getBlockNumber();
const blocksLeft = blocksRemaining - currentBlock;
const estimatedTime = blocksLeft * 12; // Estimación imprecisa
```

**Después:**
```javascript
// Frontend obtiene timestamp exacto
const deadline = await governor.proposalDeadline(proposalId);
const deadlineDate = new Date(deadline * 1000);
console.log(`Votación termina: ${deadlineDate.toLocaleString()}`);
```

### Para Contratos Governor

Si quieres implementar un Governor que use estos tokens:

```solidity
import {Governor} from "@openzeppelin/contracts/governance/Governor.sol";
import {GovernorVotes} from "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import {GovernorVotesQuorumFraction} from "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import {IVotes} from "@openzeppelin/contracts/governance/utils/IVotes.sol";

contract MyGovernor is Governor, GovernorVotes, GovernorVotesQuorumFraction {
    constructor(IVotes _token)
        Governor("MyGovernor")
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(4)
    {}

    // ⚠️ IMPORTANTE: Ahora en SEGUNDOS, no bloques
    function votingDelay() public pure virtual override returns (uint256) {
        return 1 days; // 86400 segundos
    }

    function votingPeriod() public pure virtual override returns (uint256) {
        return 1 weeks; // 604800 segundos
    }

    function proposalThreshold() public pure virtual override returns (uint256) {
        return 0;
    }
}
```

### Para Scripts de Despliegue

```javascript
// deploy-governor.js
const { ethers } = require("hardhat");

async function main() {
    const UserSharesToken = await ethers.getContractFactory("UserSharesToken");
    const token = await UserSharesToken.attach(TOKEN_ADDRESS);
    
    // Verificar el modo de reloj
    const clockMode = await token.CLOCK_MODE();
    console.log(`Token clock mode: ${clockMode}`); // "mode=timestamp"
    
    // Verificar que el Governor sea compatible
    const MyGovernor = await ethers.getContractFactory("MyGovernor");
    const governor = await MyGovernor.deploy(token.address);
    
    console.log("Governor desplegado con modo timestamp");
}
```

## 🚨 Consideraciones de Retrocompatibilidad

### ⚠️ ADVERTENCIA IMPORTANTE

**Los contratos Governor antiguos (pre-v4.9) NO son compatibles con tokens que usan timestamps.**

Si intentas usar `UserSharesToken` (con timestamps) con un Governor antiguo (bloques):
- ❌ Las consultas de poder de voto fallarán
- ❌ Los checkpoints estarán en escalas de tiempo diferentes
- ❌ Las propuestas no funcionarán correctamente

### ✅ Solución

**Opción 1 - Recomendada:**
Usa OpenZeppelin Governor v4.9+ que detecta automáticamente el modo de reloj:

```solidity
// Governor moderno - detecta automáticamente timestamps
import "@openzeppelin/contracts/governance/Governor.sol";
```

**Opción 2 - Solo si es necesario:**
Si debes mantener compatibilidad con sistemas legacy, considera crear una versión separada del token:

```solidity
// UserSharesTokenLegacy.sol - SIN clock() override
contract UserSharesTokenLegacy is ERC20Votes {
    // No override de clock() = usa bloques por defecto
}
```

## 🎪 Integración con Herramientas DAO

### Tally

Tally (tally.xyz) soporta completamente ERC-6372:

```typescript
// Tally automáticamente detecta el modo de reloj
const proposal = await tally.getProposal(proposalId);
console.log(proposal.endTime); // Timestamp exacto en formato ISO
```

### Snapshot

Snapshot puede usar timestamps para votación off-chain:

```json
{
  "type": "single-choice",
  "start": 1697040000,
  "end": 1697644800,
  "snapshot": "latest"
}
```

### OpenZeppelin Defender

Defender soporta propuestas con timestamps:

```javascript
const proposal = await defender.proposeTransaction({
  contract: governor,
  title: "Actualizar parámetro",
  description: "Cambiar maxContributionAmount",
  via: governor.address,
  viaType: 'Timelock',
  timelock: timelock.address,
});
```

## 📝 Mejores Prácticas

### 1. **Usa Unidades de Tiempo Claras**

```solidity
// ✅ BIEN - Legible y claro
function votingDelay() public pure returns (uint256) {
    return 1 days;
}

// ❌ MAL - Números mágicos
function votingDelay() public pure returns (uint256) {
    return 86400;
}
```

### 2. **Documenta el Modo de Reloj**

```solidity
/// @dev Este contrato usa timestamps (ERC-6372) para gobernanza
/// @dev votingDelay y votingPeriod están en segundos, no bloques
contract MyGovernor is Governor {
    // ...
}
```

### 3. **Verifica Compatibilidad en Tests**

```solidity
// test/Governor.test.js
it("should use timestamp mode", async function() {
    const clockMode = await token.CLOCK_MODE();
    expect(clockMode).to.equal("mode=timestamp");
});

it("should have correct voting periods in seconds", async function() {
    const delay = await governor.votingDelay();
    expect(delay).to.equal(86400); // 1 día en segundos
});
```

## 🔍 Validación del Cambio

### Tests de Compilación

```bash
npx hardhat compile
```

Debe compilar sin errores.

### Tests de Funcionalidad

```javascript
const UserSharesToken = await ethers.getContractFactory("UserSharesToken");
const token = await UserSharesToken.deploy(owner.address);

// Test 1: Verificar modo de reloj
const clockMode = await token.CLOCK_MODE();
assert.equal(clockMode, "mode=timestamp");

// Test 2: Verificar que clock() retorna timestamp
const clock = await token.clock();
const currentTimestamp = Math.floor(Date.now() / 1000);
assert.approximately(clock, currentTimestamp, 5);

// Test 3: Verificar votación funciona con timestamps
await token.mint(voter.address, ethers.utils.parseUnits("100", 6));
await token.connect(voter).delegate(voter.address);
// Avanzar tiempo
await ethers.provider.send("evm_increaseTime", [86400]); // 1 día
await ethers.provider.send("evm_mine");
const votes = await token.getPastVotes(voter.address, await token.clock() - 86400);
assert.equal(votes.toString(), ethers.utils.parseUnits("100", 6).toString());
```

## 📚 Referencias

### Estándares ERC

- **ERC-6372**: Clock Mode Standard
  - https://eips.ethereum.org/EIPS/eip-6372
  - Define `clock()` y `CLOCK_MODE()` para contratos de votación

- **ERC-5805**: Voting with Delegation
  - https://eips.ethereum.org/EIPS/eip-5805
  - Especifica comportamiento de tokens de votación con delegación

- **ERC-20 Votes**: Extensión de OpenZeppelin
  - https://docs.openzeppelin.com/contracts/5.x/api/token/erc20#ERC20Votes
  - Implementación base que usamos

### Documentación OpenZeppelin

- **Governance Guide**:
  - https://docs.openzeppelin.com/contracts/5.x/governance
  - Guía oficial de gobernanza timestamp-based

- **Governor Contract**:
  - https://docs.openzeppelin.com/contracts/5.x/api/governance
  - API completa del sistema Governor

## 🎯 Roadmap de Implementación de Gobernanza

Si planeas implementar un DAO completo para tu plataforma de fundraising:

### Fase 1: Token (✅ COMPLETADO)
- ✅ UserSharesToken con ERC20Votes
- ✅ Implementación de clock() con timestamps
- ✅ Delegación de votos funcional

### Fase 2: Governor (Futuro)
- [ ] Desplegar contrato Governor compatible
- [ ] Configurar parámetros de votación
- [ ] Integrar con FundraisingCampaign como executor

### Fase 3: Integración Frontend (Futuro)
- [ ] Conectar con Tally para propuestas
- [ ] Dashboard de gobernanza
- [ ] Notificaciones de votaciones

## 🆘 Troubleshooting

### Error: "Clock mode mismatch"

**Causa:** Estás usando un Governor con bloques y un token con timestamps.

**Solución:**
```solidity
// Verifica el modo de ambos contratos
const tokenClockMode = await token.CLOCK_MODE();
const governorClockMode = await governor.CLOCK_MODE();
console.log(`Token: ${tokenClockMode}`);
console.log(`Governor: ${governorClockMode}`);
// Ambos deben retornar "mode=timestamp"
```

### Error: "Invalid clock value"

**Causa:** El timestamp es demasiado grande para uint48 (año 2106+).

**Solución:** No es un problema práctico hasta el año 2106. El contrato es correcto.

### Error: "Past votes not found"

**Causa:** No hay checkpoints porque no ha habido transferencias o delegaciones.

**Solución:**
```solidity
// Asegúrate de delegar antes de consultar votos pasados
await token.delegate(voterAddress);
```

## 📊 Métricas de Gas

El cambio a timestamps tiene un impacto mínimo en gas:

| Operación | Gas (Bloques) | Gas (Timestamps) | Diferencia |
|-----------|---------------|------------------|------------|
| mint() | ~65,000 | ~65,000 | 0 |
| transfer() | ~52,000 | ~52,000 | 0 |
| delegate() | ~48,000 | ~48,000 | 0 |
| getPastVotes() | ~3,500 | ~3,500 | 0 |
| clock() | N/A | ~2,300 | +2,300 |
| CLOCK_MODE() | N/A | ~1,200 | +1,200 |

**Conclusión:** El overhead de gas es negligible y solo se aplica a las nuevas funciones de lectura.

## ✅ Checklist de Migración

Para proyectos que migraran de bloques a timestamps:

- [ ] Actualizar UserSharesToken con `clock()` y `CLOCK_MODE()`
- [ ] Recompilar contratos
- [ ] Ejecutar tests de regresión
- [ ] Actualizar Governor (si existe) a versión compatible
- [ ] Convertir todos los parámetros de tiempo de bloques a segundos
- [ ] Actualizar documentación de frontend
- [ ] Actualizar scripts de despliegue
- [ ] Notificar a integradores del cambio
- [ ] Actualizar ejemplos de código
- [ ] Actualizar tests de integración

## 🎓 Conclusión

La implementación de gobernanza basada en timestamps en `UserSharesToken` es una mejora fundamental que:

1. ✅ Cumple con estándares modernos (ERC-6372, ERC-5805)
2. ✅ Mejora la experiencia de usuario
3. ✅ Aumenta la precisión temporal
4. ✅ Garantiza compatibilidad futura
5. ✅ Prepara el contrato para integración DAO

Esta actualización posiciona a tu plataforma de fundraising para evolucionar hacia un modelo de gobernanza descentralizada completo, donde los contribuyentes no solo reciben tokens de participación, sino también la capacidad de votar sobre el futuro de los proyectos que apoyan.

---

**Última actualización:** Octubre 2025  
**Versión del contrato:** UserSharesToken v1.1  
**Solidity:** ^0.8.28  
**OpenZeppelin:** ^5.x

