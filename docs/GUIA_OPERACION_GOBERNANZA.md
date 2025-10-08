# 🏛️ Guía de Operación del Sistema de Gobernanza DAO

Esta guía explica cómo desplegar y operar el sistema completo de gobernanza descentralizada para el contrato FundraisingCampaign.

## 📋 Tabla de Contenidos

1. [Introducción al Sistema](#introducción-al-sistema)
2. [Flujo Completo de Operación](#flujo-completo-de-operación)
3. [Script 1: DeployGovernance.ts](#script-1-deploygovernancets)
4. [Script 2: setup-governance.ts](#script-2-setup-governancets)
5. [Script 3: create-proposal.ts](#script-3-create-proposalts)
6. [Script 4: vote-proposal.ts](#script-4-vote-proposalts)
7. [Tabla de Referencia de Variables](#tabla-de-referencia-de-variables)

---

## 🎯 Introducción al Sistema

El sistema de gobernanza consta de **4 componentes principales**:

1. **UserSharesToken (u-SHARE)**: Token ERC20 con poder de voto otorgado a los contribuyentes
2. **FundraisingGovernor**: Contrato principal de gobernanza que gestiona propuestas y votaciones
3. **TimelockController**: Capa de seguridad que retrasa la ejecución de propuestas aprobadas por 2 días
4. **FundraisingCampaign**: Contrato de campaña que será controlado por la DAO

### Parámetros de Gobernanza

- **Retraso de votación**: 1 día (las propuestas no pueden votarse inmediatamente)
- **Período de votación**: 7 días (una semana para votar)
- **Umbral de propuesta**: 0 tokens (cualquiera puede proponer)
- **Quórum**: 4% del suministro total debe votar
- **Retraso del Timelock**: 2 días (después de aprobación antes de ejecución)

---

## 🔄 Flujo Completo de Operación

```
┌─────────────────────────────────────────────────────────────────────┐
│ PASO 1: Desplegar Campaña y Obtener Direcciones                    │
│ ↓ Ya debes tener: CAMPAIGN_ADDRESS, TOKEN_ADDRESS                  │
└─────────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│ PASO 2: Desplegar Sistema de Gobernanza                            │
│ ↓ Script: DeployGovernance.ts                                      │
│ ↓ Resultado: TIMELOCK_ADDRESS, GOVERNOR_ADDRESS                    │
└─────────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│ PASO 3: Configurar Permisos y Roles                                │
│ ↓ Script: setup-governance.ts                                      │
│ ↓ Acción: Otorgar roles y transferir propiedad a Timelock          │
└─────────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│ PASO 4: Los usuarios delegan su poder de voto                      │
│ ↓ Función: token.delegate(yourAddress)                             │
│ ↓ Nota: Sin delegación, no puedes proponer ni votar                │
└─────────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│ PASO 5: Crear Propuesta de Gobernanza                              │
│ ↓ Script: create-proposal.ts                                       │
│ ↓ Resultado: PROPOSAL_ID                                           │
└─────────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│ PASO 6: Esperar Retraso de Votación (1 día)                        │
│ ↓ Estado: Pending → Active                                         │
└─────────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│ PASO 7: Votar en la Propuesta                                      │
│ ↓ Script: vote-proposal.ts                                         │
│ ↓ Opciones: 0=Contra, 1=A favor, 2=Abstención                      │
└─────────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│ PASO 8: Esperar Fin del Período de Votación (7 días)               │
│ ↓ Estado: Active → Succeeded (si aprobada) o Defeated (rechazada)  │
└─────────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│ PASO 9: Encolar Propuesta Aprobada                                 │
│ ↓ Función: governor.queue()                                        │
│ ↓ Estado: Succeeded → Queued                                       │
└─────────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│ PASO 10: Esperar Retraso del Timelock (2 días)                     │
│ ↓ Período de revisión comunitaria antes de ejecución               │
└─────────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│ PASO 11: Ejecutar Propuesta                                        │
│ ↓ Función: governor.execute()                                      │
│ ↓ Estado: Queued → Executed                                        │
│ ✅ ¡Cambios aplicados!                                             │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 📜 Script 1: DeployGovernance.ts

### Ubicación
```
ignition/modules/DeployGovernance.ts
```

### Propósito
Despliega el sistema completo de gobernanza: TimelockController y FundraisingGovernor.

### Parámetros Configurables

#### Dentro del Código (Líneas 29-33):
```typescript
const minDelay = 2 * 24 * 60 * 60;  // 2 días en segundos
const proposers = [];                // Se agregará el Governor después
const executors = ["0x0000000000000000000000000000000000000000"]; // Dirección cero = cualquiera puede ejecutar
const admin = deployer;              // Deployer inicialmente
```

**Puedes modificar**:
- `minDelay`: Tiempo de retraso del Timelock en segundos
  - Por defecto: 172,800 segundos (2 días)
  - Recomendado: Mínimo 1 día para seguridad

#### Parámetros Requeridos al Ejecutar:

**`tokenAddress`** (OBLIGATORIO):
- **Descripción**: Dirección del contrato UserSharesToken (u-SHARE)
- **Cómo obtenerlo**: 
  - Despliega primero `FundraisingCampaign`
  - Obtén la dirección del token desde la consola del deployment
  - O consulta: `campaign.userSharesToken()`
  - **Dirección actual en Fuji**: `0x762A5B1CEC9475563F4acE29efE568DA23C5566f`

### Comando de Ejecución

```bash
# Red Local
npx hardhat ignition deploy ignition/modules/DeployGovernance.ts --parameters '{"GovernanceModule":{"tokenAddress":"0x762A5B1CEC9475563F4acE29efE568DA23C5566f"}}'

# Avalanche Fuji
npx hardhat ignition deploy ignition/modules/DeployGovernance.ts --network avalancheFuji --parameters '{"GovernanceModule":{"tokenAddress":"0x762A5B1CEC9475563F4acE29efE568DA23C5566f"}}'
```

### Resultado del Deployment
Guarda estas direcciones en tu archivo `.env`:
```env
TIMELOCK_ADDRESS=0x...  # Dirección del TimelockController
GOVERNOR_ADDRESS=0x...  # Dirección del FundraisingGovernor
```

---

## ⚙️ Script 2: setup-governance.ts

### Ubicación
```
scripts/setup-governance.ts
```

### Propósito
Configura los roles y permisos del sistema de gobernanza después del deployment. Este script es **crítico** para la seguridad y debe ejecutarse inmediatamente después de desplegar.

### Variables de Entorno Requeridas

Agrega estas variables a tu archivo `.env`:

```env
# Obligatorias
TIMELOCK_ADDRESS=0x...           # Del deployment de GovernanceModule
GOVERNOR_ADDRESS=0x...           # Del deployment de GovernanceModule

# Opcional
CAMPAIGN_ADDRESS=0x239FcAC03f24Ed5565322B3a0c269BaDe3fD4e3C  # Para transferir propiedad
```

#### Dónde Obtener Cada Variable:

| Variable | Fuente | Método |
|----------|--------|--------|
| `TIMELOCK_ADDRESS` | Deployment de DeployGovernance.ts | Consola del deployment o archivo JSON |
| `GOVERNOR_ADDRESS` | Deployment de DeployGovernance.ts | Consola del deployment o archivo JSON |
| `CAMPAIGN_ADDRESS` | Deployment previo de FundraisingCampaign | README.md o SnowTrace |

### Acciones Realizadas

El script ejecuta automáticamente:

1. ✅ **Otorgar PROPOSER_ROLE al Governor** en el Timelock
2. ✅ **Verificar ADMIN_ROLE** del Timelock a sí mismo
3. ✅ **Verificar EXECUTOR_ROLE** para dirección cero (ejecución pública)
4. ✅ **Transferir propiedad de Campaign** al Timelock (si se proporciona `CAMPAIGN_ADDRESS`)
5. ⚠️ **Advertir sobre ADMIN_ROLE del deployer** (debe revocarse manualmente después de verificar)

### Comando de Ejecución

```bash
# Red Local
npx hardhat run scripts/setup-governance.ts

# Avalanche Fuji
npx hardhat run scripts/setup-governance.ts --network avalancheFuji
```

### Paso Crítico de Seguridad

Después de ejecutar el script y verificar que todo funciona:

```javascript
// Descomentar líneas 123-127 en setup-governance.ts y ejecutar nuevamente
const tx5 = await timelock.revokeRole(ADMIN_ROLE, deployer.address);
await tx5.wait();
console.log("✅ Deployer's ADMIN_ROLE revoked");
```

O ejecutar manualmente en la consola:
```bash
cast send $TIMELOCK_ADDRESS "revokeRole(bytes32,address)" $ADMIN_ROLE $DEPLOYER_ADDRESS --private-key $PRIVATE_KEY
```

---

## 💡 Script 3: create-proposal.ts

### Ubicación
```
scripts/create-proposal.ts
```

### Propósito
Crea una propuesta de gobernanza para modificar parámetros del contrato FundraisingCampaign.

### Variables de Entorno Requeridas

```env
GOVERNOR_ADDRESS=0x...           # Dirección del FundraisingGovernor
CAMPAIGN_ADDRESS=0x239FcAC03f24Ed5565322B3a0c269BaDe3fD4e3C
TOKEN_ADDRESS=0x762A5B1CEC9475563F4acE29efE568DA23C5566f
```

#### Dónde Obtener Cada Variable:

| Variable | Fuente | Método |
|----------|--------|--------|
| `GOVERNOR_ADDRESS` | Deployment de GovernanceModule | Resultado del Paso 2 |
| `CAMPAIGN_ADDRESS` | Deployment inicial | Ver README.md |
| `TOKEN_ADDRESS` | Deployment inicial | Ver README.md o `campaign.userSharesToken()` |

### Parámetros Configurables en el Código

#### Líneas 64-66 - Nueva Propuesta:
```typescript
const newMaxAmount = ethers.parseUnits("10000", 6); // Nueva cantidad máxima en USDC
```

**Puedes modificar**:
- El valor de `newMaxAmount` según lo que desees proponer
- La función objetivo (actualmente `updateMaxContributionAmount`)

#### Líneas 74-78 - Detalles de la Propuesta:
```typescript
const targets = [CAMPAIGN_ADDRESS];              // Contratos a modificar
const values = [0];                              // ETH a enviar (0 para llamadas)
const calldatas = [encodedFunctionCall];         // Datos de la función codificada
const description = "Proposal #1: Update max contribution amount to 10,000 USDC";
```

**Puedes modificar**:
- `targets`: Arreglo de direcciones de contratos a ejecutar
- `values`: Arreglo de cantidades de ETH a enviar (normalmente [0])
- `description`: Descripción clara de la propuesta (usado para generar el proposal ID)

### Requisitos Previos

Antes de ejecutar, el proponente debe:

1. **Tener tokens u-SHARE**: Contribuir a la campaña
2. **Delegar poder de voto**: Ejecutar `token.delegate(tuDirección)`
   ```javascript
   const token = await ethers.getContractAt("UserSharesToken", TOKEN_ADDRESS);
   await token.delegate(await ethers.getSigner().getAddress());
   ```
3. **Cumplir umbral de propuesta**: Por defecto es 0, pero puede cambiar

### Comando de Ejecución

```bash
# Avalanche Fuji
npx hardhat run scripts/create-proposal.ts --network avalancheFuji
```

### Resultado del Script

El script imprimirá:
- ✅ ID de la propuesta (GUARDA ESTE NÚMERO)
- ⏰ Fechas de snapshot y deadline
- 📊 Estado actual de la propuesta
- 🔗 URL de Tally.xyz para seguimiento

Guarda el **Proposal ID** para el siguiente paso:
```env
PROPOSAL_ID=123456789012345678901234567890  # Número grande
```

---

## 🗳️ Script 4: vote-proposal.ts

### Ubicación
```
scripts/vote-proposal.ts
```

### Propósito
Permite a los poseedores de tokens u-SHARE votar en una propuesta activa.

### Variables de Entorno Requeridas

```env
GOVERNOR_ADDRESS=0x...                              # Dirección del Governor
TOKEN_ADDRESS=0x762A5B1CEC9475563F4acE29efE568DA23C5566f
PROPOSAL_ID=123456789012345678901234567890         # Del script anterior
VOTE=1                                              # 0=Contra, 1=A favor, 2=Abstención
```

#### Dónde Obtener Cada Variable:

| Variable | Fuente | Método |
|----------|--------|--------|
| `GOVERNOR_ADDRESS` | Deployment de GovernanceModule | Mismo que create-proposal.ts |
| `TOKEN_ADDRESS` | Deployment inicial | Mismo que create-proposal.ts |
| `PROPOSAL_ID` | Resultado de create-proposal.ts | Consola del script anterior |
| `VOTE` | Decisión del votante | 0 (Contra), 1 (A favor), o 2 (Abstención) |

### Parámetros Configurables

#### Variable de Entorno VOTE:
```bash
VOTE=1  # A favor de la propuesta
VOTE=0  # En contra de la propuesta
VOTE=2  # Abstención (cuenta para quórum pero no afecta resultado)
```

### Opciones de Voto

| Valor | Significado | Efecto en Quórum | Efecto en Resultado |
|-------|-------------|------------------|---------------------|
| 0 | Contra | No cuenta | Voto negativo |
| 1 | A favor | Cuenta para quórum | Voto positivo |
| 2 | Abstención | Cuenta para quórum | No afecta resultado |

### Requisitos Previos

1. **La propuesta debe estar ACTIVE**: Esperar 1 día después de crearla
2. **No haber votado antes**: Cada dirección solo puede votar una vez
3. **Tener poder de voto en el snapshot**: Haber delegado antes de crear la propuesta

### Comando de Ejecución

```bash
# Votar A FAVOR
PROPOSAL_ID=123... VOTE=1 npx hardhat run scripts/vote-proposal.ts --network avalancheFuji

# Votar EN CONTRA
PROPOSAL_ID=123... VOTE=0 npx hardhat run scripts/vote-proposal.ts --network avalancheFuji

# Abstención
PROPOSAL_ID=123... VOTE=2 npx hardhat run scripts/vote-proposal.ts --network avalancheFuji
```

### Información que Muestra el Script

- ✅ Confirmación del voto
- 📊 Conteo actualizado de votos (A favor, Contra, Abstención)
- 📈 Estado del quórum (alcanzado o no)
- ⏰ Tiempo restante para votar
- 🔗 Próximos pasos según el resultado

---

## 📊 Tabla de Referencia de Variables

### Variables por Script

| Variable | Deploy<br>Governance | Setup<br>Governance | Create<br>Proposal | Vote<br>Proposal | Dónde Obtener |
|----------|:--------------------:|:-------------------:|:------------------:|:----------------:|---------------|
| `tokenAddress` | ✅ (param) | ❌ | ❌ | ❌ | Deployment de Campaign |
| `TIMELOCK_ADDRESS` | ❌ | ✅ | ❌ | ❌ | Resultado de Deploy Governance |
| `GOVERNOR_ADDRESS` | ❌ | ✅ | ✅ | ✅ | Resultado de Deploy Governance |
| `CAMPAIGN_ADDRESS` | ❌ | ⚠️ (opcional) | ✅ | ❌ | README.md o Deployment inicial |
| `TOKEN_ADDRESS` | ❌ | ❌ | ✅ | ✅ | README.md o `campaign.userSharesToken()` |
| `PROPOSAL_ID` | ❌ | ❌ | ❌ | ✅ | Resultado de Create Proposal |
| `VOTE` | ❌ | ❌ | ❌ | ✅ | Decisión del votante (0/1/2) |

**Leyenda**:
- ✅ = Obligatorio
- ⚠️ = Opcional pero recomendado
- ❌ = No usado

### Direcciones Actuales en Avalanche Fuji

```env
# Contratos Desplegados
CAMPAIGN_ADDRESS=0x239FcAC03f24Ed5565322B3a0c269BaDe3fD4e3C
TOKEN_ADDRESS=0x762A5B1CEC9475563F4acE29efE568DA23C5566f
MOCK_USDC_ADDRESS=0x47BD05Be91f58efD2149B4e479E2eE3B3efF8d5E

# Contratos de Gobernanza (completar después del deployment)
TIMELOCK_ADDRESS=0x...
GOVERNOR_ADDRESS=0x...
```

---

## 🚨 Errores Comunes y Soluciones

### Error: "No voting power"
**Causa**: No has delegado tu poder de voto.
**Solución**:
```javascript
const token = await ethers.getContractAt("UserSharesToken", TOKEN_ADDRESS);
await token.delegate(tuDireccion);
```

### Error: "Proposal is not in Active state"
**Causa**: Intentaste votar antes de que pase el retraso de 1 día.
**Solución**: Espera 24 horas después de crear la propuesta.

### Error: "Already voted"
**Causa**: Ya votaste en esta propuesta.
**Solución**: No puedes cambiar tu voto. Cada dirección vota solo una vez.

### Error: "Please set GOVERNOR_ADDRESS..."
**Causa**: Falta configurar variables de entorno.
**Solución**: Crea o edita tu archivo `.env` con todas las variables requeridas.

### Error: "Insufficient voting power"
**Causa**: No tienes suficientes tokens para proponer.
**Solución**: Adquiere más tokens u-SHARE contribuyendo a la campaña.

---

## 🔗 Recursos Adicionales

### Documentación Relacionada
- [Guía Completa de Mecánicas DAO de OpenZeppelin](./OPENZEPPELIN_DAO_MECHANICS_COMPLETE_GUIDE.md)
- [Implementación de Gobernanza Basada en Timestamps](./TIMESTAMP_BASED_GOVERNANCE_IMPLEMENTATION.md)
- [Guía de Usuario de FundraisingCampaign](./GUIA_USUARIO_CONTRATO_FUNDRAISING_ES.md)

### Enlaces Externos
- [OpenZeppelin Governor](https://docs.openzeppelin.com/contracts/4.x/governance)
- [Tally.xyz - Interfaz de Gobernanza](https://www.tally.xyz/)
- [Avalanche Testnet Explorer](https://testnet.snowtrace.io/)

### Comandos Útiles de Hardhat

```bash
# Compilar contratos
npx hardhat compile

# Ejecutar tests
npx hardhat test

# Limpiar artifacts
npx hardhat clean

# Ver cuentas configuradas
npx hardhat accounts --network avalancheFuji

# Verificar contrato en SnowTrace
npx hardhat verify --network avalancheFuji DIRECCION_CONTRATO "arg1" "arg2"
```

---

## ✅ Checklist de Operación Completa

### Fase 1: Deployment Inicial
- [ ] Desplegar FundraisingCampaign (ya hecho)
- [ ] Obtener y guardar `TOKEN_ADDRESS`
- [ ] Obtener y guardar `CAMPAIGN_ADDRESS`
- [ ] Verificar contratos en SnowTrace

### Fase 2: Deployment de Gobernanza
- [ ] Ejecutar `DeployGovernance.ts` con `tokenAddress`
- [ ] Guardar `TIMELOCK_ADDRESS`
- [ ] Guardar `GOVERNOR_ADDRESS`
- [ ] Verificar contratos de gobernanza en SnowTrace

### Fase 3: Configuración
- [ ] Configurar archivo `.env` con todas las variables
- [ ] Ejecutar `setup-governance.ts`
- [ ] Verificar que todos los roles se otorgaron correctamente
- [ ] Transferir propiedad de Campaign a Timelock
- [ ] Revocar ADMIN_ROLE del deployer (después de pruebas)

### Fase 4: Preparación para Gobernanza
- [ ] Contribuir a la campaña para obtener tokens u-SHARE
- [ ] Delegar poder de voto: `token.delegate(tuDireccion)`
- [ ] Verificar poder de voto: `token.getVotes(tuDireccion)`

### Fase 5: Ciclo de Propuesta
- [ ] Crear propuesta con `create-proposal.ts`
- [ ] Guardar `PROPOSAL_ID`
- [ ] Esperar 1 día (retraso de votación)
- [ ] Votar con `vote-proposal.ts`
- [ ] Esperar 7 días (período de votación)
- [ ] Encolar propuesta si fue aprobada: `governor.queue()`
- [ ] Esperar 2 días (retraso del timelock)
- [ ] Ejecutar propuesta: `governor.execute()`

### Fase 6: Verificación
- [ ] Confirmar que los cambios se aplicaron
- [ ] Verificar nuevo estado del contrato
- [ ] Documentar el proposal ID y resultado

---

**Última actualización**: Octubre 2025
**Versión de Solidity**: 0.8.28
**Red de Prueba**: Avalanche Fuji Testnet

---

Para cualquier pregunta o problema, consulta la documentación completa o revisa los contratos fuente en `contracts/`.

