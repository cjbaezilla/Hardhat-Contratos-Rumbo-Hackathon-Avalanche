# 📚 Documentación del Proyecto - Fundraising Campaign DAO

Bienvenido a la documentación completa del sistema de fundraising descentralizado con gobernanza DAO. Este directorio contiene guías técnicas, manuales de usuario, documentación de pruebas y guías de implementación.

## 📋 Índice General

- [Guías de Usuario](#-guías-de-usuario)
- [Documentación de Contratos Inteligentes](#-documentación-de-contratos-inteligentes)
- [Documentación de Pruebas](#-documentación-de-pruebas)
- [Guías Técnicas de Implementación](#-guías-técnicas-de-implementación)
- [Gobernanza y DAO](#-gobernanza-y-dao)

---

## 👥 Guías de Usuario

### [GUIA_USUARIO_CONTRATO_FUNDRAISING_ES.md](./GUIA_USUARIO_CONTRATO_FUNDRAISING_ES.md)
**Idioma:** 🇪🇸 Español | **Nivel:** Principiante

Guía completa para usuarios que desean crear o contribuir a campañas de fundraising.

**Contenido:**
- ¿Qué es el contrato FundraisingCampaign?
- Características clave (Anti-Whale, Tokenización, Reembolsos)
- Ciclo de vida de una campaña
- Tokens de participación y poder de voto DAO
- Características de seguridad
- Guía paso a paso para contribuyentes
- Guía paso a paso para creadores
- Funciones administrativas avanzadas
- Escenarios comunes y mejores prácticas
- Solución de problemas

**Ideal para:** Usuarios finales, creadores de campañas, contribuyentes

---

### [FUNDRAISING_CAMPAIGN_USER_GUIDE_EN.md](./FUNDRAISING_CAMPAIGN_USER_GUIDE_EN.md)
**Idioma:** 🇬🇧 English | **Nivel:** Beginner

Versión en inglés de la guía de usuario completa del contrato FundraisingCampaign.

**Contenido:**
- Complete contract overview
- Anti-whale protection mechanisms
- Share tokenization with DAO governance
- Campaign lifecycle explanation
- Step-by-step guides for contributors and creators
- Advanced administrative functions
- Common scenarios and best practices
- Technical requirements and troubleshooting

**Ideal para:** International users, campaign creators, contributors

---

## 🔧 Documentación de Contratos Inteligentes

### [GUIA_OPERACION_GOBERNANZA.md](./GUIA_OPERACION_GOBERNANZA.md)
**Idioma:** 🇪🇸 Español | **Nivel:** Intermedio-Avanzado

Guía operacional completa para desplegar y operar el sistema de gobernanza DAO.

**Contenido:**
- Introducción al sistema de gobernanza (4 componentes)
- Flujo completo de operación (11 pasos detallados)
- Script 1: DeployGovernance.ts - Despliegue del sistema
- Script 2: setup-governance.ts - Configuración de permisos y roles
- Script 3: create-proposal.ts - Creación de propuestas
- Script 4: vote-proposal.ts - Votación en propuestas
- Tabla de referencia de variables de entorno
- Errores comunes y soluciones
- Checklist de operación completa

**Ideal para:** DevOps, administradores de sistemas, desarrolladores que despliegan el DAO

---

## 📝 Documentación de Pruebas

### [DOCUMENTACION_PRUEBAS_CONTRATO_FUNDRAISING.md](./DOCUMENTACION_PRUEBAS_CONTRATO_FUNDRAISING.md)
**Idioma:** 🇪🇸 Español | **Nivel:** Avanzado

Documentación exhaustiva de las 107 pruebas del contrato FundraisingCampaign.

**Contenido:**
- Resumen del conjunto de pruebas (107 tests, 100% pasando)
- Arquitectura y configuración de pruebas con Forge
- Análisis detallado por categoría:
  - Pruebas del Constructor (9 tests)
  - Pruebas de Contribución (30 tests) - con 15 casos edge nuevos
  - Pruebas de Retiro de Fondos (8 tests)
  - Pruebas de Reembolso (12 tests)
  - Pruebas de Funciones de Actualización (10 tests)
  - Pruebas de Funciones de Consulta (8 tests)
  - Casos Extremos (1 test)
  - Pruebas de Fecha Límite (4 tests)
  - Pruebas de Integración Complejas (6 tests)
- Decisiones de diseño y racionalización
- Consideraciones de seguridad y rendimiento
- Mejoras específicas en tests de contribución (Diciembre 2024)

**Ideal para:** Desarrolladores, auditores de seguridad, QA engineers

---

### [FUNDRAISING_CAMPAIGN_TEST_DOCUMENTATION.md](./FUNDRAISING_CAMPAIGN_TEST_DOCUMENTATION.md)
**Idioma:** 🇬🇧 English | **Nivel:** Advanced

English version of the comprehensive FundraisingCampaign test suite documentation.

**Contenido:**
- Complete test suite overview (107 tests)
- Test architecture and setup with Forge-Std
- Detailed test analysis by category
- Anti-whale protection strategy testing
- Significant test coverage improvements (December 2024)
- Security considerations and performance analysis
- Edge cases and integration testing
- Design decisions and rationale

**Ideal para:** Developers, security auditors, QA engineers

---

### [FUNDRAISING_GOVERNOR_TEST_DOCUMENTATION.md](./FUNDRAISING_GOVERNOR_TEST_DOCUMENTATION.md)
**Idioma:** 🇪🇸 Español | **Nivel:** Avanzado

Documentación completa de las 34 pruebas del sistema de gobernanza FundraisingGovernor.

**Contenido:**
- Resumen del conjunto de pruebas (34 tests, 100% pasando)
- Arquitectura de pruebas con 5 contratos integrados
- Análisis detallado por categoría:
  - Constructor & Configuration Tests (6 tests)
  - Proposal Creation Tests (4 tests)
  - Voting Tests (8 tests)
  - Quorum Tests (3 tests)
  - Proposal State Tests (4 tests)
  - Timelock Integration Tests (4 tests)
  - Delegation Tests (3 tests)
  - Campaign Integration Tests (2 tests)
- Decisiones de diseño de parámetros de gobernanza
- Validaciones de seguridad críticas
- Timestamp-based voting implementation
- Comparación Before vs After Governance
- Escenarios del mundo real testeados

**Ideal para:** Desarrolladores blockchain, especialistas en DAOs, auditores

---

### [FUNDRAISING_GOVERNOR_TEST_DOCUMENTATION_EN.md](./FUNDRAISING_GOVERNOR_TEST_DOCUMENTATION_EN.md)
**Idioma:** 🇬🇧 English | **Nivel:** Advanced

English version of the comprehensive FundraisingGovernor test suite documentation.

**Contenido:**
- Complete governance system test suite (34 tests)
- Test architecture with 5 integrated contracts
- Detailed analysis by test category
- Governance parameter design decisions
- Critical security validations
- Timestamp-based voting mechanics
- Before vs After Governance comparison
- Real-world scenario testing

**Ideal para:** Blockchain developers, DAO specialists, auditors

---

## 🏗️ Guías Técnicas de Implementación

### [RAINBOWKIT_WAGMI_IMPLEMENTATION_GUIDE.md](./RAINBOWKIT_WAGMI_IMPLEMENTATION_GUIDE.md)
**Idioma:** 🇬🇧 English | **Nivel:** Intermedio-Avanzado

Guía completa de implementación de frontend Web3 usando RainbowKit, Wagmi, EthersJS y Next.js.

**Contenido:**
- Configuración de variables de entorno
- Implementación de componentes:
  - Connect Wallet Button
  - Navigation Header
  - Campaign Dashboard
- Custom Hooks para interacción con contratos:
  - `use-fundraising-campaign.ts` con todas las funciones del contrato
  - `use-usdc-balance.ts` para manejo de balances
- Integración completa con el contrato FundraisingCampaign
- Funciones administrativas avanzadas (nuevas en v1.1):
  - updateDeadline, updateGoalAmount
  - getMaxAllowedContribution, getAntiWhaleParameters
  - getUserShareBalance, checkDeadlineAndComplete
- Styling con Tailwind CSS
- Deployment a Vercel
- Troubleshooting y optimizaciones de rendimiento
- Consideraciones de seguridad

**Ideal para:** Desarrolladores frontend, Full-stack developers, Web3 developers

---

### [TIMESTAMP_BASED_GOVERNANCE_IMPLEMENTATION.md](./TIMESTAMP_BASED_GOVERNANCE_IMPLEMENTATION.md)
**Idioma:** 🇪🇸 Español | **Nivel:** Avanzado

Documentación técnica detallada sobre la implementación de gobernanza basada en timestamps.

**Contenido:**
- Resumen ejecutivo del cambio de bloques a timestamps
- Funciones agregadas: `clock()` y `CLOCK_MODE()`
- Razones del cambio:
  - Irregularidad de bloques en Avalanche
  - Estándares modernos (ERC-6372, ERC-5805)
  - Ventajas de timestamps sobre bloques
- Diferencias técnicas de implementación
- Comparación de parámetros (bloques vs timestamps)
- Impacto en integración (frontends, contratos Governor, scripts)
- Consideraciones de retrocompatibilidad
- Integración con herramientas DAO (Tally, Snapshot, Defender)
- Mejores prácticas y validación del cambio
- Tests de funcionalidad y compilación
- Roadmap de implementación de gobernanza
- Troubleshooting común
- Métricas de gas
- Checklist de migración

**Ideal para:** Arquitectos blockchain, desarrolladores de contratos, especialistas en gobernanza

---

### [TIMESTAMP_BASED_GOVERNANCE_IMPLEMENTATION_EN.md](./TIMESTAMP_BASED_GOVERNANCE_IMPLEMENTATION_EN.md)
**Idioma:** 🇬🇧 English | **Nivel:** Advanced

English version of the detailed technical documentation on timestamp-based governance implementation.

**Contenido:**
- Executive summary of the change from blocks to timestamps
- Added functions: `clock()` and `CLOCK_MODE()`
- Reasons for the change:
  - Block irregularity on Avalanche
  - Modern standards (ERC-6372, ERC-5805)
  - Advantages of timestamps over blocks
- Technical implementation differences
- Parameter comparison (blocks vs timestamps)
- Integration impact (frontends, Governor contracts, scripts)
- Backwards compatibility considerations
- DAO tools integration (Tally, Snapshot, Defender)
- Best practices and change validation
- Functionality and compilation tests
- Governance implementation roadmap
- Common troubleshooting
- Gas metrics
- Migration checklist

**Ideal para:** Blockchain architects, contract developers, governance specialists

---

## 🎓 Gobernanza y DAO

### [OPENZEPPELIN_DAO_MECHANICS_COMPLETE_GUIDE.md](./OPENZEPPELIN_DAO_MECHANICS_COMPLETE_GUIDE.md)
**Idioma:** 🇪🇸 Español | **Nivel:** Intermedio-Avanzado

Guía completa de mecánicas de DAOs con OpenZeppelin Governor desde cero.

**Contenido:**
- ¿Qué problema resuelve un sistema de gobernanza on-chain?
- Arquitectura: Los 3 Pilares (Token, Governor, Timelock)
- Explicación detallada de cada pilar:
  - **Voting Token (ERC20Votes)**: Snapshots, delegación, checkpoints
  - **Governor**: Módulos, estados de propuestas, parámetros críticos
  - **Timelock**: Security delay, roles, permisos
- Flujo completo: Ciclo de vida de una propuesta (6 pasos)
- Interacciones entre contratos
- Errores comunes y cómo evitarlos
- Block Numbers vs Timestamps
- Configuración recomendada para producción
- Ejemplo mínimo completo funcional
- Recursos útiles (OpenZeppelin Wizard, Tally, Defender)

**Ideal para:** Developers aprendiendo DAOs, arquitectos de sistemas de gobernanza

---

### [OPENZEPPELIN_DAO_MECHANICS_COMPLETE_GUIDE_EN.md](./OPENZEPPELIN_DAO_MECHANICS_COMPLETE_GUIDE_EN.md)
**Idioma:** 🇬🇧 English | **Nivel:** Intermediate-Advanced

English version of the complete guide to DAO mechanics with OpenZeppelin Governor.

**Contenido:**
- Problem statement: Why on-chain governance?
- Architecture: The 3 Pillars (Token, Governor, Timelock)
- Detailed explanation of each pillar
- Complete proposal lifecycle (6 steps)
- Contract interactions
- Common errors and prevention
- Block numbers vs timestamps comparison
- Recommended production configuration
- Complete minimal working example
- Useful resources and tools

**Ideal para:** Developers learning DAOs, governance system architects

---

## 🚀 Quick Start Guides

### Para Usuarios
1. Comienza con [GUIA_USUARIO_CONTRATO_FUNDRAISING_ES.md](./GUIA_USUARIO_CONTRATO_FUNDRAISING_ES.md)
2. Si eres creador de campaña, revisa también [GUIA_OPERACION_GOBERNANZA.md](./GUIA_OPERACION_GOBERNANZA.md)

### Para Desarrolladores
1. Revisa [OPENZEPPELIN_DAO_MECHANICS_COMPLETE_GUIDE.md](./OPENZEPPELIN_DAO_MECHANICS_COMPLETE_GUIDE.md) (o su versión [EN](./OPENZEPPELIN_DAO_MECHANICS_COMPLETE_GUIDE_EN.md)) para entender los fundamentos
2. Estudia [DOCUMENTACION_PRUEBAS_CONTRATO_FUNDRAISING.md](./DOCUMENTACION_PRUEBAS_CONTRATO_FUNDRAISING.md) (o su versión [EN](./FUNDRAISING_CAMPAIGN_TEST_DOCUMENTATION.md)) para entender la implementación
3. Lee [TIMESTAMP_BASED_GOVERNANCE_IMPLEMENTATION.md](./TIMESTAMP_BASED_GOVERNANCE_IMPLEMENTATION.md) (o su versión [EN](./TIMESTAMP_BASED_GOVERNANCE_IMPLEMENTATION_EN.md)) para detalles técnicos
4. Usa [RAINBOWKIT_WAGMI_IMPLEMENTATION_GUIDE.md](./RAINBOWKIT_WAGMI_IMPLEMENTATION_GUIDE.md) para el frontend

### Para Auditores
1. Comienza con [FUNDRAISING_CAMPAIGN_TEST_DOCUMENTATION.md](./FUNDRAISING_CAMPAIGN_TEST_DOCUMENTATION.md) (o su versión [ES](./DOCUMENTACION_PRUEBAS_CONTRATO_FUNDRAISING.md))
2. Revisa [FUNDRAISING_GOVERNOR_TEST_DOCUMENTATION.md](./FUNDRAISING_GOVERNOR_TEST_DOCUMENTATION.md) (o su versión [EN](./FUNDRAISING_GOVERNOR_TEST_DOCUMENTATION_EN.md))
3. Consulta [TIMESTAMP_BASED_GOVERNANCE_IMPLEMENTATION.md](./TIMESTAMP_BASED_GOVERNANCE_IMPLEMENTATION.md) (o su versión [EN](./TIMESTAMP_BASED_GOVERNANCE_IMPLEMENTATION_EN.md)) para validar la implementación de gobernanza

---

## 📊 Resumen de Pruebas

| Componente | Total Tests | Estado | Documentación |
|------------|-------------|--------|---------------|
| FundraisingCampaign | 107 | ✅ 100% Passing | [Ver docs](./DOCUMENTACION_PRUEBAS_CONTRATO_FUNDRAISING.md) |
| FundraisingGovernor | 34 | ✅ 100% Passing | [Ver docs](./FUNDRAISING_GOVERNOR_TEST_DOCUMENTATION.md) |
| **TOTAL** | **141** | **✅ 100%** | - |

---

## 🌐 Idiomas Disponibles

| Documento | 🇪🇸 Español | 🇬🇧 English |
|-----------|-------------|-------------|
| Guía de Usuario | ✅ GUIA_USUARIO_CONTRATO_FUNDRAISING_ES.md | ✅ FUNDRAISING_CAMPAIGN_USER_GUIDE_EN.md |
| Documentación de Tests - Campaign | ✅ DOCUMENTACION_PRUEBAS_CONTRATO_FUNDRAISING.md | ✅ FUNDRAISING_CAMPAIGN_TEST_DOCUMENTATION.md |
| Documentación de Tests - Governor | ✅ FUNDRAISING_GOVERNOR_TEST_DOCUMENTATION.md | ✅ FUNDRAISING_GOVERNOR_TEST_DOCUMENTATION_EN.md |
| Guía de Mecánicas DAO | ✅ OPENZEPPELIN_DAO_MECHANICS_COMPLETE_GUIDE.md | ✅ OPENZEPPELIN_DAO_MECHANICS_COMPLETE_GUIDE_EN.md |
| Guía de Operación | ✅ GUIA_OPERACION_GOBERNANZA.md | - |
| Implementación Timestamps | ✅ TIMESTAMP_BASED_GOVERNANCE_IMPLEMENTATION.md | ✅ TIMESTAMP_BASED_GOVERNANCE_IMPLEMENTATION_EN.md |
| Guía de Frontend | - | ✅ RAINBOWKIT_WAGMI_IMPLEMENTATION_GUIDE.md |

---

## 🔗 Links Externos Útiles

### Herramientas de Desarrollo
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [Foundry Book](https://book.getfoundry.sh/)
- [Hardhat Documentation](https://hardhat.org/docs)
- [Avalanche Documentation](https://docs.avax.network/)

### Herramientas de Gobernanza
- [Tally - Governance Dashboard](https://www.tally.xyz/)
- [Snapshot - Off-chain Voting](https://snapshot.org/)
- [OpenZeppelin Defender](https://defender.openzeppelin.com/)

### Estándares
- [ERC-20: Token Standard](https://eips.ethereum.org/EIPS/eip-20)
- [ERC-5805: Voting with Delegation](https://eips.ethereum.org/EIPS/eip-5805)
- [ERC-6372: Clock Mode](https://eips.ethereum.org/EIPS/eip-6372)

### Frontend
- [RainbowKit](https://www.rainbowkit.com/)
- [Wagmi](https://wagmi.sh/)
- [EthersJS v6](https://docs.ethers.org/v6/)
- [Next.js](https://nextjs.org/)

---

## 📞 Soporte y Contribuciones

¿Encontraste un error en la documentación? ¿Tienes sugerencias de mejora?

- Abre un issue en el repositorio
- Revisa la documentación existente antes de reportar
- Incluye referencias específicas (nombre del archivo, sección)

---

## 📅 Última Actualización

**Fecha:** Octubre 2025  
**Versión del Sistema:** 1.1  
**Solidity:** ^0.8.28  
**OpenZeppelin:** ^5.x  
**Hardhat:** ^2.x

---

## 🎯 Estado del Proyecto

| Componente | Estado | Descripción |
|------------|--------|-------------|
| 📝 Contratos | ✅ Estable | FundraisingCampaign y UserSharesToken desplegados |
| 🏛️ Gobernanza | ✅ Estable | FundraisingGovernor y Timelock funcionales |
| 🧪 Tests | ✅ 100% | 141 tests pasando (107 Campaign + 34 Governor) |
| 📚 Documentación | ✅ Completa | 12 documentos en español e inglés |
| 🌐 Frontend | 📝 En desarrollo | Guía de implementación disponible |
| 🔐 Auditoría | ⏳ Pendiente | Contratos listos para auditoría externa |

---

**¡Gracias por usar nuestro sistema de Fundraising con DAO!** 🚀

Para más información, consulta los contratos fuente en `/contracts/` o ejecuta los tests con `npx hardhat test`.

