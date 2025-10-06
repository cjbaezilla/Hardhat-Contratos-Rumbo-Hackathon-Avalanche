# FundraisingCampaign - Plataforma de Crowdfunding Descentralizada con Gobernanza DAO

Una plataforma de crowdfunding descentralizada construida en Avalanche que combina recaudación de fondos tradicional con gobernanza DAO. Los contribuyentes reciben tokens de participación que les otorgan derechos de voto en la organización autónoma descentralizada resultante.

## 🚀 Características Principales

### 💰 Crowdfunding Descentralizado
- **Recaudación de fondos en USDC**: Utiliza USDC como token de contribución estable
- **Metas y fechas límite**: Campañas con objetivos claros y duración definida
- **Sistema de reembolsos automático**: Protección para contribuyentes si no se alcanza la meta

### 🛡️ Protección Anti-Ballena
- **Límites de contribución por transacción**: Previene contribuciones excesivas en una sola operación
- **Límites de porcentaje por contribuyente**: Evita que una persona domine toda la campaña
- **Distribución equitativa**: Asegura participación amplia de la comunidad

### 🗳️ Gobernanza DAO Integrada
- **Tokens de participación (userSHARE)**: Cada contribución genera tokens de gobernanza
- **Derechos de voto**: Los tokens otorgan poder de decisión en la DAO resultante
- **Estándar ERC20Votes**: Compatible con plataformas DAO existentes
- **Transferibilidad**: Los derechos de voto pueden transferirse

### 🔒 Seguridad Avanzada
- **Protección contra reentrada**: Previene ataques de reentrancy
- **Transferencias seguras**: Utiliza SafeERC20 de OpenZeppelin
- **Control de acceso**: Solo el creador puede gestionar la campaña
- **Verificaciones de desbordamiento**: Protección contra integer overflow

## 📋 Smart Contracts

### [FundraisingCampaign.sol](contracts/FundraisingCampaign.sol)
The main contract that manages crowdfunding campaigns:
- Campaign creation and management
- Contribution processing
- Refund system
- Fund withdrawal and emergency functions
- Campaign parameter updates

### [UserSharesToken.sol](contracts/UserSharesToken.sol)
Advanced ERC20 token representing campaign shares:
- **ERC20**: Basic token functionality
- **ERC20Burnable**: Tokens can be burned
- **ERC1363**: Support for transfer callbacks
- **ERC20Permit**: Gasless approvals
- **ERC20Votes**: Integrated DAO governance

### [MockUSDC.sol](contracts/libs/MockUSDC.sol)
Simulated USDC token for testing and development:
- Basic ERC20 implementation
- 6 decimals (like real USDC)
- Configurable initial supply

## 🛠️ Tecnologías Utilizadas

- **Solidity ^0.8.28**: Lenguaje de contratos inteligentes
- **Hardhat 3**: Framework de desarrollo y testing
- **OpenZeppelin**: Bibliotecas de contratos seguros
- **Avalanche Fuji**: Red de test
- **TypeScript**: Para scripts y testing
- **Mocha**: Framework de testing
- **Ethers.js**: Interacción con blockchain

## 📁 Estructura del Proyecto

```
├── contracts/                    # Smart contracts
│   ├── [FundraisingCampaign.sol](contracts/FundraisingCampaign.sol)  # Main contract
│   ├── [UserSharesToken.sol](contracts/UserSharesToken.sol)          # Share token
│   └── libs/
│       └── [MockUSDC.sol](contracts/libs/MockUSDC.sol)               # Mock USDC
├── test/                        # Contract tests
│   └── [FundraisingCampaign.t.sol](test/FundraisingCampaign.t.sol)
├── ignition/                    # Deployment scripts
│   └── modules/
│       └── [DeployFundraisingCampaignSimple.ts](ignition/modules/DeployFundraisingCampaignSimple.ts)
├── docs/                        # Documentation
│   ├── [FUNDRAISING_CAMPAIGN_USER_GUIDE_EN.md](docs/FUNDRAISING_CAMPAIGN_USER_GUIDE_EN.md)
│   ├── [GUIA_USUARIO_CONTRATO_FUNDRAISING_ES.md](docs/GUIA_USUARIO_CONTRATO_FUNDRAISING_ES.md)
│   ├── [FUNDRAISING_CAMPAIGN_TEST_DOCUMENTATION.md](docs/FUNDRAISING_CAMPAIGN_TEST_DOCUMENTATION.md)
│   ├── [DOCUMENTACION_PRUEBAS_CONTRATO_FUNDRAISING.md](docs/DOCUMENTACION_PRUEBAS_CONTRATO_FUNDRAISING.md)
│   └── [RAINBOWKIT_WAGMI_IMPLEMENTATION_GUIDE.md](docs/RAINBOWKIT_WAGMI_IMPLEMENTATION_GUIDE.md)
└── scripts/                     # Utility scripts
```

## 🚀 Instalación y Configuración

### Prerrequisitos
- Node.js (v16 o superior)
- npm o yarn
- Git

### Instalación
```bash
# Clonar el repositorio
git clone https://github.com/cjbaezilla/Hardhat-Contratos-Rumbo-Hackathon-Avalanche.git
cd avax_hackathon_hardhat

# Instalar dependencias
npm install

# Configurar variables de entorno
cp .env.example .env
# Editar .env con tus claves privadas y URLs de RPC
```

### Variables de Entorno
```env
# Avalanche Fuji Testnet
AVALANCHE_FUJI_PRIVATE_KEY=tu_clave_privada_aqui
AVALANCHE_FUJI_RPC_URL=https://api.avax-test.network/ext/bc/C/rpc

# Sepolia (opcional)
SEPOLIA_PRIVATE_KEY=tu_clave_privada_aqui
SEPOLIA_RPC_URL=tu_url_rpc_sepolia
```

## 🧪 Testing

### Ejecutar todos los tests
```bash
npx hardhat test
```

### Ejecutar tests específicos
```bash
# Solo tests de Solidity
npx hardhat test solidity

# Solo tests de Mocha
npx hardhat test mocha
```

### Coverage de tests
```bash
npx hardhat coverage
```

## 🚀 Despliegue

### Red Local (Hardhat)
```bash
npx hardhat ignition deploy ignition/modules/DeployFundraisingCampaignSimple.ts
```

### Avalanche Fuji Testnet
```bash
npx hardhat ignition deploy --network avalancheFuji ignition/modules/DeployFundraisingCampaignSimple.ts
```

### Sepolia (opcional)
```bash
npx hardhat ignition deploy --network sepolia ignition/modules/DeployFundraisingCampaignSimple.ts
```

## 📖 Uso del Contrato

### Para Creadores de Campañas

1. **Crear una campaña**:
   ```solidity
   // Parámetros de ejemplo
   string memory title = "Mi Proyecto Innovador";
   string memory description = "Descripción detallada del proyecto";
   uint256 goalAmount = 50000 * 10**6; // 50,000 USDC
   uint256 duration = 30 days;
   uint256 maxContributionAmount = 5000 * 10**6; // 5,000 USDC máximo por transacción
   uint256 maxContributionPercentage = 2000; // 20% máximo por contribuyente
   ```

2. **Monitorear progreso**:
   ```solidity
   (uint256 goal, uint256 current, uint256 deadline, bool active, bool completed) = 
       campaign.getCampaignStats();
   ```

3. **Retirar fondos** (cuando se alcance la meta):
   ```solidity
   campaign.withdrawFunds();
   ```

### Para Contribuyentes

1. **Verificar límites de contribución**:
   ```solidity
   uint256 maxAllowed = campaign.getMaxAllowedContribution(msg.sender);
   ```

2. **Aprobar USDC y contribuir**:
   ```solidity
   usdc.approve(address(campaign), amount);
   campaign.contribute(amount);
   ```

3. **Solicitar reembolso** (si la campaña falla):
   ```solidity
   campaign.requestRefund();
   ```

## 🔄 Flujo de una Campaña

### 1. Creación
- El creador despliega el contrato con parámetros específicos
- Se acuña el token de participaciones (userSHARE)
- La campaña se marca como activa

### 2. Recaudación
- Los contribuyentes aprueban y envían USDC
- Se acuñan tokens de participaciones proporcionales
- Se actualiza el monto total recaudado

### 3. Finalización
**Éxito (meta alcanzada)**:
- El creador retira todos los fondos
- Los contribuyentes mantienen sus tokens de gobernanza
- Se forma una DAO con todos los poseedores de tokens

**Fracaso (meta no alcanzada)**:
- Los contribuyentes pueden solicitar reembolsos
- Los tokens se queman
- El creador puede retirar fondos parciales

## 🛡️ Características de Seguridad

- **ReentrancyGuard**: Previene ataques de reentrada
- **SafeERC20**: Transferencias seguras de tokens
- **Ownable**: Control de acceso al creador
- **Validaciones exhaustivas**: Verificaciones en todas las funciones
- **Protección de desbordamiento**: Checks de integer overflow
- **Límites anti-ballena**: Protección contra dominación

## 📚 Additional Documentation

- [User Guide in English](docs/FUNDRAISING_CAMPAIGN_USER_GUIDE_EN.md)
- [Guía de Usuario en Español](docs/GUIA_USUARIO_CONTRATO_FUNDRAISING_ES.md)
- [Test Documentation](docs/FUNDRAISING_CAMPAIGN_TEST_DOCUMENTATION.md)
- [Contract Testing Documentation (Spanish)](docs/DOCUMENTACION_PRUEBAS_CONTRATO_FUNDRAISING.md)
- [RainbowKit/Wagmi Implementation Guide](docs/RAINBOWKIT_WAGMI_IMPLEMENTATION_GUIDE.md)

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 🏆 Hackathon Avalanche

Este proyecto fue desarrollado para el Avalanche Hackathon, demostrando las capacidades de la red Avalanche para aplicaciones DeFi innovadoras que combinan crowdfunding tradicional con gobernanza descentralizada.

## 🔗 Enlaces Útiles

- [Avalanche Documentation](https://docs.avax.network/)
- [Hardhat Documentation](https://hardhat.org/docs)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [USDC on Avalanche](https://docs.avax.network/build/tutorials/smart-digital-assets/transfer-avax-between-x-and-p-chain)

---

**Nota**: Este es un proyecto de hackathon. Para uso en producción, se recomienda realizar auditorías de seguridad adicionales y testing exhaustivo.