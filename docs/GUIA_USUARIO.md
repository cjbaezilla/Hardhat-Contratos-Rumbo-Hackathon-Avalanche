# 🚀 Guía de Usuario - Plataforma de Fundraising Descentralizada

## 📋 Índice
1. [¿Qué es esta plataforma?](#qué-es-esta-plataforma)
2. [Requisitos previos](#requisitos-previos)
3. [Paso 1: Configurar tu billetera Web3](#paso-1-configurar-tu-billetera-web3)
4. [Paso 2: Obtener AVAX para gas (Testnet)](#paso-2-obtener-avax-para-gas-testnet)
5. [Paso 3: Obtener USDC desde el Faucet](#paso-3-obtener-usdc-desde-el-faucet)
6. [Paso 4: Contribuir a una campaña](#paso-4-contribuir-a-una-campaña)
7. [Paso 5: Recibir tokens de gobernanza](#paso-5-recibir-tokens-de-gobernanza)
8. [Paso 6: Participar en el DAO con Tally](#paso-6-participar-en-el-dao-con-tally)
9. [Funciones avanzadas](#funciones-avanzadas)
10. [Preguntas frecuentes](#preguntas-frecuentes)
11. [Solución de problemas](#solución-de-problemas)

---

## ¿Qué es esta plataforma?

Esta es una **plataforma de fundraising (financiamiento colectivo) descentralizada** construida sobre la blockchain de Avalanche. Combina lo mejor del crowdfunding tradicional con la transparencia y seguridad de la tecnología blockchain.

### 🎯 Finalidad de la Plataforma

**Para Contribuyentes:**
- Contribuir a campañas de financiamiento colectivo usando criptomonedas (USDC)
- Recibir tokens de gobernanza proporcionales a tu contribución
- Participar en decisiones sobre el uso de los fondos recaudados
- Obtener reembolsos automáticos si la campaña no alcanza su objetivo
- Transparencia total: todas las transacciones son públicas y verificables

**Para Creadores:**
- Crear campañas de fundraising sin intermediarios
- Acceso a fondos globales sin restricciones geográficas
- Protección anti-ballena para evitar concentración de poder
- Gestión transparente de fondos
- Creación automática de una DAO (Organización Autónoma Descentralizada)

### ✨ Características Principales

1. **Contribuciones en USDC**: Usa una stablecoin vinculada al dólar estadounidense
2. **Tokens de Gobernanza**: Cada contribución te da poder de voto
3. **Protección Anti-Ballena**: Límites para evitar que grandes inversores dominen
4. **Reembolsos Automáticos**: Si la campaña falla, recuperas tu dinero
5. **Integración con Tally**: Participa en la gobernanza de manera profesional
6. **Transparencia Total**: Todo en blockchain, sin secretos

---

## Requisitos Previos

Antes de comenzar, necesitas:

- ✅ Una computadora o smartphone con acceso a Internet
- ✅ Un navegador web moderno (Chrome, Firefox, Brave, Safari)
- ✅ Aproximadamente 15-30 minutos para completar la configuración inicial
- ✅ Conocimientos básicos de navegación web

**No necesitas:**
- ❌ Conocimientos previos de criptomonedas o blockchain
- ❌ Dinero real (la plataforma usa testnet - dinero de prueba)
- ❌ Experiencia técnica avanzada

---

## Paso 1: Configurar tu Billetera Web3

Una billetera Web3 es como tu cuenta bancaria digital para criptomonedas. Es necesaria para interactuar con la plataforma.

### Opción A: Core Wallet (Recomendada para Avalanche)

**¿Por qué Core?** Es la billetera oficial del ecosistema Avalanche y ofrece la mejor experiencia.

#### Instalación de Core Wallet:

1. **Visita el sitio oficial:**
   - Ve a [https://core.app/](https://core.app/)
   - Haz clic en "Download" (Descargar)

2. **Elige tu plataforma:**
   - **Navegador (extensión)**: Chrome, Firefox, Brave, Edge
   - **Móvil**: iOS o Android
   - **Escritorio**: Windows, Mac, Linux

3. **Instala la extensión del navegador** (más común):
   - Haz clic en "Add to Chrome" (o tu navegador)
   - Confirma la instalación
   - La extensión aparecerá en la esquina superior derecha

4. **Crea tu billetera:**
   - Haz clic en el icono de Core en tu navegador
   - Selecciona "Create a new wallet" (Crear nueva billetera)
   - **¡MUY IMPORTANTE!** Anota tu frase de recuperación de 12-24 palabras
   - Guárdala en un lugar seguro (papel, nunca digital)
   - Estas palabras son la ÚNICA forma de recuperar tu billetera

5. **Configura un PIN o contraseña:**
   - Elige una contraseña segura
   - Confírmala
   - ¡Listo! Tu billetera está creada

#### Configuración de Red (Automática):

**¡Buenas noticias!** No necesitas configurar la red manualmente. Cuando conectes tu billetera a la plataforma por primera vez:

- ✅ La plataforma detectará automáticamente que necesitas usar Avalanche Fuji
- ✅ Te pedirá permiso para cambiar a la red correcta
- ✅ Solo tienes que hacer clic en "Aprobar" o "Switch Network" cuando aparezca la ventana
- ✅ La red se configurará automáticamente con todos los parámetros correctos

**Proceso:**
1. Conecta tu billetera en la plataforma (botón "Connect Wallet")
2. Si no estás en la red Fuji, aparecerá una ventana emergente
3. Haz clic en "Switch Network" o "Cambiar Red"
4. ¡Listo! Ya estás en Avalanche Fuji C-Chain

**Nota:** Si Core Wallet ya tiene la red Fuji disponible por defecto, es posible que ni siquiera veas esta solicitud.

### Opción B: MetaMask (Alternativa popular)

Si prefieres MetaMask:

1. **Instala MetaMask:**
   - Ve a [https://metamask.io/](https://metamask.io/)
   - Descarga e instala la extensión
   - Crea tu billetera (similar al proceso de Core)

2. **Configuración de red (Automática):**
   - Al igual que con Core Wallet, **no necesitas configurar nada manualmente**
   - Cuando conectes MetaMask a la plataforma, esta detectará automáticamente la red
   - Te pedirá permiso para agregar y cambiar a Avalanche Fuji
   - Solo haz clic en "Aprobar" cuando aparezca la solicitud
   - La plataforma agregará automáticamente estos parámetros:
     ```
     Network Name: Avalanche Fuji C-Chain
     New RPC URL: https://api.avax-test.network/ext/bc/C/rpc
     Chain ID: 43113
     Currency Symbol: AVAX
     Block Explorer URL: https://testnet.snowtrace.io/
     ```

### 🔒 Seguridad de tu Billetera

**⚠️ ADVERTENCIAS IMPORTANTES:**

- **NUNCA compartas tu frase de recuperación** con nadie
- **NUNCA la escribas en tu computadora** (usa papel)
- **NUNCA la envíes por email o chat**
- La frase de recuperación = acceso total a tus fondos
- Nadie legítimo te pedirá tu frase de recuperación
- Si pierdes la frase, pierdes acceso a tus fondos PARA SIEMPRE

**✅ Buenas prácticas:**
- Escribe tu frase de recuperación en papel
- Guárdala en un lugar seguro (caja fuerte, lugar secreto)
- Considera hacer 2-3 copias en diferentes ubicaciones
- Usa contraseñas fuertes para tu billetera
- No uses la misma contraseña que otras cuentas

---

## Paso 2: Obtener AVAX para Gas (Testnet)

En blockchain, todas las transacciones requieren pagar una pequeña comisión llamada "gas fee" (tarifa de gas). En Avalanche, estas tarifas se pagan en AVAX.

### ¿Qué es el Gas?

El "gas" es como el combustible que necesita cada transacción para ejecutarse en la blockchain. Es un pago pequeño que se da a los validadores de la red por procesar tu transacción.

**Ejemplo de costos típicos en Avalanche Fuji:**
- Enviar USDC: ~0.001 AVAX ($0.00003)
- Aprobar tokens: ~0.001 AVAX
- Contribuir a campaña: ~0.002-0.005 AVAX

### Obtener AVAX de Testnet (Gratis)

Como estamos en testnet, el AVAX no tiene valor real. Puedes obtenerlo gratis:

#### Opción 1: Core Faucet (Recomendado)

1. **Visita el faucet de Core:**
   - Ve a [https://core.app/tools/testnet-faucet/](https://core.app/tools/testnet-faucet/)

2. **Conecta tu billetera:**
   - Haz clic en "Connect Wallet"
   - Selecciona Core Wallet o MetaMask
   - Autoriza la conexión

3. **Copia tu dirección:**
   - En Core Wallet, haz clic en tu dirección (empieza con 0x...)
   - Se copiará al portapapeles

4. **Solicita AVAX:**
   - Pega tu dirección en el campo
   - Selecciona "Fuji (C-Chain)"
   - Haz clic en "Request Tokens"
   - Espera 10-30 segundos

5. **Verifica que recibiste los fondos:**
   - Abre tu billetera
   - Deberías ver ~2 AVAX en tu balance

#### Opción 2: Avalanche Builder Console

1. **Ve a:**
   - [https://build.avax.network/console/primary-network/faucet](https://build.avax.network/console/primary-network/faucet)

2. **Sigue el proceso:**
   - Ingresa tu dirección
   - Completa el CAPTCHA
   - Solicita tokens

### ¿Cuánto AVAX necesito?

Para usar la plataforma cómodamente:
- **Mínimo**: 0.5 AVAX (para ~50-100 transacciones)
- **Recomendado**: 1-2 AVAX (para ~200-400 transacciones)

Puedes solicitar más AVAX del faucet cuando lo necesites.

---

## Paso 3: Obtener USDC desde el Faucet

El USDC (USD Coin) es la moneda que usarás para contribuir a las campañas. Es una stablecoin, lo que significa que su valor está vinculado al dólar estadounidense (1 USDC = $1 USD).

### ¿Por qué USDC?

- **Estabilidad**: No fluctúa como Bitcoin o Ethereum
- **Fácil de entender**: 1 USDC = 1 dólar
- **Ampliamente aceptado**: Es una de las stablecoins más confiables
- **Transparencia**: Cada USDC está respaldado por $1 USD real

### Acceder al Faucet de USDC

1. **Ve a la página del Faucet:**
   - En la plataforma, busca el menú de navegación
   - Haz clic en "Faucet" o visita directamente: [https://fuji.enanos.club/faucet/](https://fuji.enanos.club/faucet/)

2. **Conecta tu billetera:**
   - Si no está conectada, haz clic en "Connect Wallet"
   - Selecciona tu billetera (Core o MetaMask)
   - Autoriza la conexión
   - Tu dirección aparecerá en la esquina superior derecha

3. **Verifica tu balance actual:**
   - En la página del Faucet verás:
     - Tu balance actual de USDC
     - La cantidad que recibirás (generalmente 1,000 USDC)

4. **Solicitar USDC:**
   - Haz clic en el botón "Mint USDC" o "Get Test USDC"
   - Se abrirá tu billetera pidiendo confirmación
   - **Revisa los detalles de la transacción:**
     - Gas fee: ~0.001 AVAX
     - Red: Avalanche Fuji C-Chain
   - Haz clic en "Confirm" o "Confirmar"

5. **Esperar confirmación:**
   - La transacción tomará 2-5 segundos en procesarse
   - Verás una notificación de éxito
   - Tu nuevo balance de USDC aparecerá actualizado

### ¿Cuánto USDC necesito?

Depende de cuánto quieras contribuir:

- **Para probar**: 10-100 USDC
- **Contribución pequeña**: 100-500 USDC
- **Contribución mediana**: 500-2,000 USDC
- **Contribución grande**: 2,000+ USDC (sujeto a límites anti-ballena)

**Nota:** Puedes usar el faucet múltiples veces si necesitas más USDC.

### Verificar tu Balance de USDC

Puedes verificar tu balance en dos lugares:

1. **En tu billetera:**
   - Abre Core Wallet o MetaMask
   - Deberías ver el token USDC listado
   - Si no aparece, agrégalo manualmente con esta dirección:
     ```
     Token Contract: (ver en la página del faucet o variable de entorno)
     Symbol: USDC
     Decimals: 6
     ```

2. **En la plataforma:**
   - Tu balance de USDC aparece en la página de Fundraising
   - También en las tarjetas informativas superiores

---

## Paso 4: Contribuir a una Campaña

Ahora que tienes AVAX para gas y USDC para contribuir, estás listo para participar en una campaña de fundraising.

### Entender el Proceso de Contribución

La contribución es un proceso de **2 pasos** (la primera vez):

**Paso A - Aprobación (Approval):**
- Le das permiso al contrato para usar tu USDC
- Solo se hace una vez (o cuando el límite aprobado se agota)
- Costo: ~0.001 AVAX en gas

**Paso B - Contribución:**
- El contrato toma el USDC de tu billetera
- Te envía tokens de gobernanza a cambio
- Costo: ~0.002-0.005 AVAX en gas

### Pasos para Contribuir

#### 1. Ir a la página de Fundraising

- En el menú principal, haz clic en "Fundraising" o "Ver Campaña"
- O accede directamente aquí: https://fuji.enanos.club/fundraising/
- Verás la página de la campaña activa

#### 2. Revisar la información de la campaña

Antes de contribuir, revisa:

**Información básica:**
- **Título y descripción**: ¿De qué trata la campaña?
- **Objetivo (Goal)**: Cantidad total a recaudar
- **Recaudado (Raised)**: Cantidad actual recaudada
- **Progreso**: Barra de progreso visual
- **Tiempo restante**: Cuenta regresiva hasta la fecha límite

**Tu información personal:**
- **Balance de USDC**: Cuánto USDC tienes disponible
- **Tu contribución**: Cuánto has contribuido (si ya contribuiste antes)
- **Máximo permitido**: Límite máximo que puedes contribuir (protección anti-ballena)
- **Tus tokens de gobernanza**: Cuántos tokens tienes

**Límites anti-ballena:**
- **Máximo por transacción**: Ej: $10,000 USDC por contribución
- **Máximo por contribuyente**: Ej: 20% del objetivo total

#### 3. Decidir cuánto contribuir

Consideraciones:

- **¿Cuánto quieres apoyar?** Decide según tus posibilidades
- **Límite máximo**: No puedes exceder tu límite permitido
- **Estrategia de gobernanza**: Más contribución = más tokens = más poder de voto
- **Balance disponible**: Asegúrate de tener suficiente USDC

**Ejemplo:**
```
Objetivo de la campaña: $50,000 USDC
Ya recaudado: $25,000 USDC (50%)
Límite por contribuyente: 20% del objetivo = $10,000 USDC máximo
Tu balance: 5,000 USDC
Tu límite disponible: $10,000 USDC (no has contribuido antes)

Puedes contribuir: Entre 1 y 5,000 USDC (limitado por tu balance)
```

#### 4. Ingresar la cantidad

1. **Encuentra el campo de entrada:**
   - Busca "Cantidad a contribuir" o "Amount to Contribute"
   
2. **Ingresa tu cantidad:**
   - Escribe el número en USDC
   - Ejemplo: `500` (para 500 USDC)
   - No uses símbolos de moneda

3. **Revisa los indicadores:**
   - ✅ Verde: Cantidad válida, lista para continuar
   - ⚠️ Amarillo: Necesitas aprobar USDC primero
   - ❌ Rojo: Error (excede límites, balance insuficiente, etc.)

#### 5. Aprobar USDC (Primera vez o cuando sea necesario)

Si es tu primera contribución o tu aprobación previa se agotó:

1. **Verás un botón** que dice:
   - "Approve USDC Spending" (Aprobar gasto de USDC)
   - "Autorizar USDC"

2. **Haz clic en el botón:**
   - Se abrirá tu billetera
   - Verás una solicitud de aprobación

3. **Revisa la aprobación:**
   ```
   Token: USDC
   Spender: [Dirección del contrato de Fundraising]
   Amount: 1,000,000 USDC (generalmente se aprueba un monto grande)
   Gas: ~0.001 AVAX
   ```

4. **Confirma en tu billetera:**
   - Haz clic en "Confirm" o "Confirmar"
   - Espera 2-5 segundos
   - Verás un mensaje de éxito

5. **¿Por qué se aprueba tanto?**
   - Para evitar aprobar cada vez que contribuyes
   - Es seguro: el contrato solo puede tomar lo que tú explícitamente contribuyas
   - Puedes revocar la aprobación cuando quieras

#### 6. Realizar la contribución

Después de aprobar (o si ya tenías aprobación previa):

1. **El botón cambiará a:**
   - "Contribute to Campaign" (Contribuir a la campaña)
   - "Contribuir"

2. **Haz clic en el botón:**
   - Se abrirá tu billetera nuevamente
   - Verás los detalles de la transacción

3. **Revisa la transacción:**
   ```
   Acción: Contribute
   Cantidad: [Tu cantidad] USDC
   Gas: ~0.002-0.005 AVAX
   Red: Avalanche Fuji C-Chain
   ```

4. **Confirma la transacción:**
   - Verifica que todo sea correcto
   - Haz clic en "Confirm" o "Confirmar"

5. **Espera la confirmación:**
   - La transacción se procesará en 2-5 segundos
   - Verás un mensaje de éxito
   - ¡Felicidades! Has contribuido exitosamente

#### 7. Verificar tu contribución

Después de contribuir, deberías ver:

1. **Balance actualizado:**
   - Tu balance de USDC disminuyó
   - Tu balance de tokens de gobernanza aumentó

2. **Progreso de la campaña:**
   - La barra de progreso se actualizó
   - El monto recaudado aumentó

3. **Tu contribución:**
   - Apareces en "Tu contribución" con el monto total

4. **Contribuciones recientes:**
   - Tu contribución aparece en la lista de contribuciones recientes

### Guía Visual del Proceso

```
┌─────────────────────────────────────┐
│  Paso 1: Revisar Campaña            │
│  ✓ Leer descripción                 │
│  ✓ Ver objetivo y progreso          │
│  ✓ Verificar tiempo restante        │
└─────────────────────────────────────┘
           ↓
┌─────────────────────────────────────┐
│  Paso 2: Decidir Cantidad            │
│  ✓ Verificar tu balance              │
│  ✓ Revisar límites                   │
│  ✓ Ingresar cantidad                 │
└─────────────────────────────────────┘
           ↓
┌─────────────────────────────────────┐
│  Paso 3: Aprobar USDC (primera vez) │
│  ✓ Clic en "Approve"                │
│  ✓ Confirmar en billetera            │
│  ✓ Esperar confirmación              │
└─────────────────────────────────────┘
           ↓
┌─────────────────────────────────────┐
│  Paso 4: Contribuir                  │
│  ✓ Clic en "Contribute"              │
│  ✓ Confirmar en billetera            │
│  ✓ Esperar confirmación              │
└─────────────────────────────────────┘
           ↓
┌─────────────────────────────────────┐
│  Paso 5: ¡Listo!                     │
│  ✓ Recibiste tokens de gobernanza   │
│  ✓ Puedes votar en el DAO            │
│  ✓ Eres parte del proyecto          │
└─────────────────────────────────────┘
```

### Contribuciones múltiples

Puedes contribuir más de una vez a la misma campaña:

- **Ventajas:**
  - Aumentar tu poder de voto
  - Apoyar más el proyecto
  - Acumular más tokens

- **Límites:**
  - No puedes exceder el límite total por contribuyente
  - La campaña debe seguir activa
  - Debes tener suficiente USDC

**Ejemplo de contribución múltiple:**
```
Primera contribución: 500 USDC → 500 tokens
Segunda contribución: 300 USDC → 300 tokens
Total: 800 USDC → 800 tokens de gobernanza
```

---

## Paso 5: Recibir Tokens de Gobernanza

Después de contribuir, automáticamente recibes tokens de gobernanza. Estos tokens representan tu participación en el proyecto y te dan poder de voto.

### ¿Qué son los Tokens de Gobernanza?

Los tokens de gobernanza (llamados "Share Tokens" o "U-SHARE") son tokens ERC-20 que:

1. **Representan tu participación:**
   - Proporción: 1 USDC contribuido = 1 token de gobernanza
   - Ejemplo: Contribuiste 500 USDC → Recibes 500 tokens

2. **Te dan poder de voto:**
   - Más tokens = más poder de voto en decisiones
   - 1 token = 1 voto en la mayoría de propuestas

3. **Son transferibles:**
   - Puedes enviarlos a otras direcciones
   - Puedes delegar tu poder de voto a otros

4. **Son permanentes:**
   - No expiran
   - Los conservas después de que termine la campaña

### Cómo Verificar tus Tokens

#### En la Plataforma

1. **Página de Fundraising:**
   - Busca la sección "Tu información" o "Your Info"
   - Verás "Tus tokens de gobernanza" o "Your Share Balance"
   - Ejemplo: `500 U-SHARE`

2. **Tarjetas informativas:**
   - En la parte superior de la página
   - Tarjeta morada/púrpura con información de tokens

#### En tu Billetera

Para ver los tokens en Core Wallet o MetaMask:

1. **Abre tu billetera**

2. **Agregar token personalizado:**
   - Core Wallet: Settings → Manage Tokens → Add Custom Token
   - MetaMask: Assets → Import Tokens

3. **Ingresa la información del token:**
   ```
   Token Contract Address: [Ver en la plataforma o variables de entorno]
   Token Symbol: U-SHARE
   Token Decimals: 6
   ```

4. **Guarda:**
   - El token aparecerá en tu lista de activos
   - Verás tu balance actualizado

### Cálculo de Tokens

La fórmula es simple:

```
Tokens recibidos = Cantidad contribuida en USDC × 1

Ejemplos:
- Contribuyes 100 USDC → Recibes 100 tokens
- Contribuyes 1,000 USDC → Recibes 1,000 tokens
- Contribuyes 5,500 USDC → Recibes 5,500 tokens
```

### Poder de Voto Proporcional

Tu poder de voto es proporcional a tus tokens:

**Ejemplo de escenario:**
```
Total recaudado en la campaña: 50,000 USDC
Total de tokens emitidos: 50,000 tokens

Tu contribución: 500 USDC
Tus tokens: 500 tokens
Tu poder de voto: 500/50,000 = 1% del total

Si una propuesta necesita 51% para aprobar:
- Se necesitan: 25,500 votos
- Tu contribución: 500 votos (1%)
```

### ¿Qué Puedo Hacer con Mis Tokens?

1. **Votar en propuestas:**
   - Usar fondos del proyecto
   - Cambios en la campaña
   - Decisiones estratégicas
   - Contrataciones, gastos, etc.

2. **Delegar tu voto:**
   - Dar tu poder de voto a alguien de confianza
   - Útil si no tienes tiempo de participar activamente
   - Puedes revocar la delegación cuando quieras

3. **Crear propuestas:**
   - Si tienes suficientes tokens (generalmente 1-5% del total)
   - Proponer cambios o uso de fondos
   - La comunidad vota tu propuesta

4. **Transferir tokens:**
   - Enviar a otra dirección
   - Vender (si hay mercado)
   - Regalar a otros miembros

### Tokens y Reembolsos

**Importante:** Si solicitas un reembolso:

- ❌ **Pierdes tus tokens de gobernanza**
- ❌ **Pierdes tu poder de voto**
- ✅ **Recuperas tu USDC**

**Ejemplo:**
```
Situación inicial:
- Contribución: 1,000 USDC
- Tokens: 1,000 U-SHARE

Solicitas reembolso:
- Recibes: 1,000 USDC
- Pierdes: 1,000 U-SHARE
- Tu poder de voto: 0%
```

---

## Paso 6: Participar en el DAO con Tally

Tally es una plataforma profesional para la gobernanza de DAOs (Organizaciones Autónomas Descentralizadas). Te permite votar en propuestas, crear propuestas y participar activamente en las decisiones del proyecto.

### ¿Qué es Tally?

**Tally** ([tally.xyz](https://tally.xyz)) es una plataforma que facilita:

- 📊 Visualizar propuestas de gobernanza
- 🗳️ Votar en propuestas con tus tokens
- ✍️ Crear nuevas propuestas
- 👥 Delegar tu poder de voto
- 📈 Ver estadísticas y análisis del DAO
- 💬 Discutir con otros miembros

### Acceder al DAO desde la Plataforma

1. **En la página de Fundraising:**
   - Busca la sección destacada con icono morado/púrpura
   - Verás "Ver DAO en Tally" o "View DAO on Tally"
   - Hay un enlace a: `https://www.tally.xyz/gov/dao-prueba-fundraising-1`

2. **Haz clic en el enlace:**
   - Se abrirá una nueva pestaña
   - Llegarás al DAO del proyecto en Tally

### Configurar tu Cuenta en Tally

#### Primera vez en Tally:

1. **Conectar tu billetera:**
   - En Tally, haz clic en "Connect Wallet" (esquina superior derecha)
   - Selecciona tu billetera (Core Wallet o MetaMask)
   - Autoriza la conexión
   - Tally detectará automáticamente tus tokens

2. **Verifica tu poder de voto:**
   - En tu perfil verás:
     - Tus tokens de gobernanza
     - Tu porcentaje de poder de voto
     - Propuestas en las que has votado

3. **Completa tu perfil (opcional):**
   - Agrega un nombre de usuario
   - Avatar/foto
   - Descripción
   - Enlaces sociales

### Entender la Interfaz de Tally

#### Página Principal del DAO:

**Sección superior:**
- **Nombre del DAO**: "DAO Prueba Fundraising 1"
- **Estadísticas**:
  - Total de tokens
  - Número de holders (poseedores)
  - Propuestas activas
  - Participación en votaciones

**Pestañas principales:**

1. **Proposals (Propuestas):**
   - Lista de todas las propuestas
   - Estado: Activa, Aprobada, Rechazada, Ejecutada
   - Filtros por estado

2. **Delegates (Delegados):**
   - Lista de miembros con poder de voto delegado
   - Top votantes
   - Estadísticas de participación

3. **Voters (Votantes):**
   - Lista de todos los poseedores de tokens
   - Cuántos tokens tiene cada uno
   - Historial de votación

4. **About (Acerca de):**
   - Información del DAO
   - Contratos inteligentes
   - Parámetros de gobernanza

### Votar en Propuestas

#### Encontrar propuestas activas:

1. **Ve a la pestaña "Proposals"**

2. **Filtra por "Active":**
   - Verás solo las propuestas en votación activa
   - Aparecerá el tiempo restante para votar

3. **Haz clic en una propuesta:**
   - Se abrirá la página de detalles

#### Entender una propuesta:

**Información clave:**

1. **Título y descripción:**
   - ¿Qué se está proponiendo?
   - Ejemplo: "Contratar diseñador UX por 3 meses"

2. **Detalles técnicos:**
   - **Proposer**: Quién creó la propuesta
   - **Created**: Fecha de creación
   - **Start/End**: Inicio y fin de la votación
   - **Actions**: Acciones técnicas que se ejecutarán si se aprueba

3. **Opciones de voto:**
   - **For (A favor)**: Estás de acuerdo con la propuesta
   - **Against (En contra)**: No estás de acuerdo
   - **Abstain (Abstención)**: Neutral, no tomas posición

4. **Resultados actuales:**
   - Votos a favor
   - Votos en contra
   - Abstenciones
   - Barra de progreso visual
   - Quorum (% mínimo de participación necesario)

#### Emitir tu voto:

1. **Lee la propuesta completa:**
   - Descripción
   - Justificación
   - Impacto esperado
   - Comentarios de otros miembros

2. **Decide tu posición:**
   - ¿Estás de acuerdo?
   - ¿Beneficia al proyecto?
   - ¿Tiene sentido económicamente?

3. **Haz clic en tu opción:**
   - "Vote For" (Votar a favor)
   - "Vote Against" (Votar en contra)
   - "Abstain" (Abstenerse)

4. **Confirma tu voto:**
   - Se abrirá tu billetera
   - Revisa la transacción
   - Gas: ~0.001-0.002 AVAX
   - Confirma

5. **Espera confirmación:**
   - 2-5 segundos
   - Tu voto se registrará en blockchain
   - Verás tu voto reflejado en la propuesta

6. **Opcional - Agregar comentario:**
   - Explica por qué votaste así
   - Ayuda a otros miembros a decidir
   - Fomenta la discusión constructiva

#### Cambiar tu voto:

En algunos DAOs puedes cambiar tu voto antes de que termine la votación:

- Solo si el DAO lo permite
- Antes de que cierre la votación
- Costo: otra transacción de gas

### Crear una Propuesta

Si tienes suficientes tokens (generalmente 1-5% del total), puedes crear propuestas:

#### Requisitos:

1. **Tokens suficientes:**
   - Verifica el "proposal threshold" (umbral de propuesta)
   - Ejemplo: Si el total es 50,000 tokens y el umbral es 2%, necesitas 1,000 tokens

2. **Buena idea:**
   - Clara y específica
   - Beneficia al proyecto
   - Factible de ejecutar

#### Pasos para crear una propuesta:

1. **Haz clic en "New Proposal":**
   - Botón en la página del DAO
   - Solo visible si tienes suficientes tokens

2. **Completa el formulario:**

   **Título:**
   ```
   Ejemplo: "Contratar desarrollador full-time por 6 meses"
   ```

   **Descripción:**
   ```markdown
   ## Resumen
   Propongo contratar un desarrollador full-time para mejorar la plataforma.

   ## Justificación
   - Necesitamos agregar nuevas funcionalidades
   - El proyecto está creciendo rápidamente
   - La comunidad ha pedido estas mejoras

   ## Detalles
   - Puesto: Desarrollador Full-Stack
   - Duración: 6 meses
   - Presupuesto: $30,000 USDC (6 meses × $5,000/mes)
   - Tareas específicas: [lista detallada]

   ## Beneficios esperados
   - Más funcionalidades
   - Mejor experiencia de usuario
   - Mayor valor del proyecto
   ```

   **Acciones (técnico):**
   - Si la propuesta implica transferir fondos o ejecutar código
   - Requiere conocimientos técnicos
   - Puedes pedir ayuda a la comunidad

3. **Revisar y publicar:**
   - Revisa todo cuidadosamente
   - Una vez publicado, no puedes editar
   - Haz clic en "Submit Proposal"

4. **Confirmar transacción:**
   - Se abrirá tu billetera
   - Costo: ~0.001-0.005 AVAX
   - Confirma

5. **Período de espera:**
   - Generalmente hay un "voting delay" de 1-2 días
   - Permite a la comunidad revisar antes de votar

6. **Votación activa:**
   - La votación estará activa por un período determinado (ej: 3-7 días)
   - Promociona tu propuesta en los canales de la comunidad
   - Responde preguntas y dudas

### Delegar tu Poder de Voto

Si no tienes tiempo de participar activamente, puedes delegar tu poder de voto a alguien de confianza.

#### ¿Qué es la delegación?

**Delegar** significa:
- ✅ Das tu poder de voto a otro miembro
- ✅ Esa persona vota con tus tokens
- ✅ Puedes revocar cuando quieras
- ❌ NO pierdes tus tokens
- ❌ NO puedes votar mientras delegas

#### Cuándo delegar:

- ✅ No tienes tiempo de seguir todas las propuestas
- ✅ Confías en alguien más experimentado
- ✅ Quieres apoyar a un miembro activo
- ✅ Prefieres enfocarte en otros aspectos

#### Cómo delegar:

1. **Ve a la pestaña "Delegates":**
   - Lista de delegados potenciales
   - Ordenados por poder de voto

2. **Investiga a los delegados:**
   - **Historial de votación**: ¿Participa activamente?
   - **Alignment**: ¿Sus valores coinciden con los tuyos?
   - **Transparencia**: ¿Explica sus votos?
   - **Disponibilidad**: ¿Responde preguntas?

3. **Selecciona un delegado:**
   - Haz clic en su perfil
   - Revisa su información completa
   - Lee sus razones y filosofía

4. **Delega tus tokens:**
   - Haz clic en "Delegate"
   - Se abrirá tu billetera
   - Confirma la transacción (gas: ~0.001 AVAX)

5. **Verificar delegación:**
   - En tu perfil verás "Delegated to: [dirección]"
   - Tus tokens siguen en tu billetera
   - El delegado ahora vota con tu poder

#### Auto-delegación:

Por defecto, podrías necesitar **delegarte a ti mismo** para activar tu poder de voto:

1. Ve a tu perfil en Tally
2. Haz clic en "Delegate"
3. Ingresa tu propia dirección
4. Confirma la transacción
5. ¡Ahora puedes votar!

#### Revocar delegación:

Para recuperar tu poder de voto:

1. Ve a tu perfil
2. Haz clic en "Delegate"
3. Ingresa tu propia dirección (te delegas a ti mismo)
4. Confirma
5. Ya puedes votar nuevamente

### Mejores Prácticas en el DAO

#### Como votante:

1. **Participa activamente:**
   - Lee todas las propuestas
   - Vota en cada una
   - Tu voto importa

2. **Sé informado:**
   - Investiga antes de votar
   - Lee los comentarios de otros
   - Pregunta si tienes dudas

3. **Piensa a largo plazo:**
   - ¿Beneficia al proyecto?
   - ¿Es sostenible?
   - ¿Está alineado con la visión?

4. **Sé constructivo:**
   - Da feedback útil
   - Explica tus razones
   - Ayuda a mejorar propuestas

#### Como creador de propuestas:

1. **Sé claro y específico:**
   - Título descriptivo
   - Detalles completos
   - Presupuesto exacto

2. **Justifica bien:**
   - ¿Por qué es necesario?
   - ¿Qué problema resuelve?
   - ¿Cuáles son los beneficios?

3. **Sé transparente:**
   - Revela conflictos de interés
   - Comparte toda la información relevante
   - Responde preguntas honestamente

4. **Escucha feedback:**
   - Acepta críticas constructivas
   - Ajusta si es necesario
   - Aprende para próximas propuestas

### Tipos de Propuestas Comunes

1. **Uso de fondos:**
   - Gastos operativos
   - Contrataciones
   - Marketing y promoción
   - Desarrollo de funcionalidades

2. **Cambios de gobernanza:**
   - Modificar quorum
   - Cambiar períodos de votación
   - Ajustar umbrales de propuesta

3. **Cambios de parámetros:**
   - Límites de contribución
   - Protección anti-ballena
   - Fechas límite de campaña

4. **Alianzas y colaboraciones:**
   - Partnerships con otros proyectos
   - Integraciones técnicas
   - Eventos conjuntos

5. **Distribuciones:**
   - Airdrops a contribuyentes
   - Recompensas a miembros activos
   - Incentivos por participación

---

## Funciones Avanzadas

### Reembolsos

Si la campaña no alcanza su objetivo o está inactiva, puedes solicitar un reembolso.

#### ¿Cuándo puedes pedir reembolso?

✅ **Puedes pedir reembolso si:**
- La campaña terminó sin alcanzar el objetivo
- La campaña está inactiva
- Has contribuido con USDC
- No has solicitado reembolso previamente

❌ **NO puedes pedir reembolso si:**
- La campaña alcanzó su objetivo exitosamente
- La campaña todavía está activa
- Ya solicitaste tu reembolso anteriormente
- No tienes contribuciones

#### Proceso de reembolso:

1. **Verifica el estado:**
   - Ve a la página de Fundraising
   - Si eres elegible, verás una sección de reembolso
   - Color amarillo con información clara

2. **Revisa tu contribución:**
   - Verás cuánto USDC contribuiste
   - Este es el monto que recibirás de vuelta

3. **Solicita el reembolso:**
   - Haz clic en "Request Refund" o "Solicitar Reembolso"
   - Se abrirá tu billetera
   - Revisa la transacción (gas: ~0.002-0.005 AVAX)
   - Confirma

4. **Espera la confirmación:**
   - La transacción se procesa en 2-5 segundos
   - Recibirás tu USDC de vuelta
   - Perderás tus tokens de gobernanza

5. **Verifica tu balance:**
   - Tu USDC debe haber aumentado
   - Tus tokens de gobernanza deben ser 0

**Importante:** El reembolso es definitivo. Una vez procesado:
- ✅ Recuperas tu USDC
- ❌ Pierdes tus tokens de gobernanza
- ❌ Pierdes tu poder de voto en el DAO
- ❌ No puedes volver a contribuir a esa campaña

### Múltiples Contribuciones

Puedes contribuir varias veces a la misma campaña:

**Ventajas:**
- Acumulas más tokens de gobernanza
- Aumentas tu poder de voto
- Apoyas más al proyecto
- Flexibilidad (contribuye cuando puedas)

**Consideraciones:**
- Respeta los límites anti-ballena totales
- Cada contribución requiere gas
- Tus contribuciones se suman

**Ejemplo:**
```
Límite total por contribuyente: 10,000 USDC

Contribución 1: 2,000 USDC (20% de tu límite usado)
Contribución 2: 3,000 USDC (50% de tu límite usado)
Contribución 3: 1,500 USDC (65% de tu límite usado)
Contribución 4: 3,500 USDC (100% de tu límite usado) ✅ OK

Contribución 5: 500 USDC ❌ RECHAZADA (excede límite)

Total contribuido: 10,000 USDC
Total tokens: 10,000 U-SHARE
```

### Ver Contribuciones Recientes

En la página de Fundraising, puedes ver:

**Lista de contribuciones:**
- Avatar del contribuyente
- Dirección (abreviada): `0x1234...5678`
- Cantidad contribuida
- Fecha de la contribución

**Información útil:**
- Ver quiénes son los top contribuyentes
- Verificar que tu contribución aparece
- Transparencia total del proyecto
- Seguir el progreso en tiempo real

### Explorador de Blockchain (Snowtrace)

Todas las transacciones son públicas en blockchain. Puedes verificarlas:

1. **Obtén el hash de tu transacción:**
   - En mensajes de éxito, hay un enlace "View on Explorer"
   - O copia el hash de transacción (empieza con 0x...)

2. **Ve a Snowtrace Testnet:**
   - [https://testnet.snowtrace.io/](https://testnet.snowtrace.io/)

3. **Busca tu transacción:**
   - Pega el hash en el buscador
   - Verás detalles completos:
     - Estado: Success o Failed
     - Block Number
     - Timestamp
     - Gas usado
     - Todas las acciones internas

4. **Verifica el contrato:**
   - Puedes ver el código del smart contract
   - Todas las funciones
   - Eventos emitidos
   - Transparencia total

---

## Preguntas Frecuentes

### Generales

**P: ¿Esto es dinero real?**
R: No, la plataforma usa la testnet de Avalanche. Todo el USDC y AVAX son tokens de prueba sin valor real. Es un entorno seguro para aprender.

**P: ¿Necesito pagar algo?**
R: No. Todo el dinero (AVAX, USDC) es de testnet y se obtiene gratis desde faucets. Solo necesitas conexión a Internet.

**P: ¿Es seguro conectar mi billetera?**
R: Sí, siempre que uses la plataforma legítima. Nunca compartas tu frase de recuperación. La plataforma solo puede leer tu balance y ejecutar transacciones que tú apruebes.

**P: ¿Puedo usar esto en móvil?**
R: Sí, con billeteras móviles como Core Wallet o MetaMask Mobile. La experiencia es similar.

### Sobre Billeteras

**P: ¿Qué pasa si pierdo mi frase de recuperación?**
R: Pierdes acceso a tu billetera PARA SIEMPRE. No hay forma de recuperarla. Por eso es crucial guardarla de forma segura.

**P: ¿Puedo usar la misma billetera para testnet y mainnet?**
R: Sí, pero son redes separadas. Tus fondos de testnet no son reales y viceversa. Siempre verifica en qué red estás.

**P: ¿Core Wallet o MetaMask?**
R: Ambas funcionan bien. Core es más optimizada para Avalanche. MetaMask es más universal. Elige según tu preferencia.

### Sobre Contribuciones

**P: ¿Cuál es el mínimo que puedo contribuir?**
R: Técnicamente, cualquier cantidad mayor a 0. Sin embargo, considera que cada transacción tiene un costo de gas (~0.002 AVAX). Contribuciones muy pequeñas (ej: 0.01 USDC) no son prácticas.

**P: ¿Puedo cancelar una contribución?**
R: Una vez confirmada, no puedes cancelar. Si la campaña falla o está inactiva, puedes solicitar un reembolso.

**P: ¿Por qué necesito aprobar dos veces?**
R: No son dos transacciones iguales:
1. **Approval**: Das permiso al contrato para usar tu USDC (una sola vez)
2. **Contribute**: El contrato efectivamente toma tu USDC y te da tokens (cada vez que contribuyes)

**P: ¿Qué pasa si la campaña no alcanza su objetivo?**
R: Puedes solicitar un reembolso completo. Recuperarás tu USDC pero perderás tus tokens de gobernanza.

### Sobre Tokens de Gobernanza

**P: ¿Puedo vender mis tokens de gobernanza?**
R: Técnicamente son transferibles, pero como es testnet, no tienen valor real. En una versión de producción (mainnet), podrían tener mercados secundarios.

**P: ¿Los tokens expiran?**
R: No, son permanentes. Los conservas mientras tengas la billetera.

**P: ¿Puedo tener tokens de múltiples campañas?**
R: Actualmente la plataforma maneja una campaña a la vez, pero técnicamente podrías participar en múltiples campañas si existieran.

### Sobre Gobernanza y DAO

**P: ¿Tengo que votar en todas las propuestas?**
R: No es obligatorio, pero se recomienda. Tu participación hace al DAO más fuerte y legítimo.

**P: ¿Qué pasa si no voto en una propuesta?**
R: La propuesta se decide con los votos de quienes participaron. Tu voto se considera neutral/abstenido.

**P: ¿Puedo votar después de delegar?**
R: No. Si delegaste, solo tu delegado puede votar con tus tokens. Para votar, primero revoca la delegación.

**P: ¿Cómo sé si mi voto fue contado?**
R: Después de votar, verás tu voto reflejado en la propuesta de Tally. También puedes verificar la transacción en Snowtrace.

### Técnicas

**P: ¿Por qué mi transacción falló?**
R: Razones comunes:
- Gas insuficiente (necesitas más AVAX)
- USDC insuficiente
- No aprobaste USDC primero
- Excediste los límites anti-ballena
- La campaña terminó o está inactiva

**P: ¿Qué es el "gas" y por qué tengo que pagarlo?**
R: Gas es la tarifa que pagas a los validadores de la red por procesar tu transacción. Es como un sello postal para cartas, pero digital.

**P: ¿Por qué algunas transacciones cuestan más gas que otras?**
R: Transacciones más complejas (como contribuir por primera vez) requieren más computación, por lo tanto más gas. Transacciones simples (como transferir USDC) cuestan menos.

**P: ¿Puedo ajustar el gas que pago?**
R: Sí, en configuraciones avanzadas de tu billetera. Sin embargo, en Avalanche las tarifas son muy bajas (~$0.0001-0.001), así que no suele ser necesario.

### Sobre la Plataforma

**P: ¿Quién controla la plataforma?**
R: Los smart contracts son descentralizados y están en blockchain. Una vez desplegados, funcionan automáticamente según su código. El creador de la campaña tiene algunos controles administrativos, pero las contribuciones y reembolsos son automáticos.

**P: ¿Puedo crear mi propia campaña?**
R: Actualmente la plataforma muestra una campaña específica. Para crear tu propia campaña, necesitarías desplegar una nueva instancia del contrato (requiere conocimientos técnicos).

**P: ¿Dónde van los fondos cuando contribuyo?**
R: Van al smart contract de la campaña. Si la campaña alcanza el objetivo, el creador puede retirarlos. Si falla, quedan disponibles para reembolsos.

---

## Solución de Problemas

### Problemas de Conexión

**Problema:** "No puedo conectar mi billetera"

**Soluciones:**
1. Verifica que instalaste la extensión correctamente
2. Actualiza tu navegador a la última versión
3. Prueba deshabilitando otras extensiones de blockchain
4. Intenta en modo incógnito
5. Prueba otro navegador
6. Verifica que la extensión esté habilitada en la configuración del navegador

**Problema:** "Mi billetera se desconecta constantemente"

**Soluciones:**
1. Revisa la configuración de permisos del sitio web
2. No cierres la ventana de la billetera mientras usas la plataforma
3. Desconecta y vuelve a conectar manualmente
4. Borra caché y cookies del navegador

### Problemas con la Red

**Problema:** "Wrong network" o "Red incorrecta"

**Soluciones:**
1. **Método automático (recomendado):**
   - Refresca la página de la plataforma
   - Haz clic en "Connect Wallet" nuevamente
   - La plataforma te pedirá cambiar de red automáticamente
   - Acepta el cambio haciendo clic en "Switch Network" o "Aprobar"

2. **Método manual (si el automático no funciona):**
   - Abre tu billetera
   - Busca en el selector de redes "Avalanche Fuji C-Chain"
   - Selecciónala manualmente
   - Refresca la página de la plataforma

3. **Si la red no aparece en tu billetera:**
   - Desconecta tu billetera de la plataforma
   - Vuelve a hacer clic en "Connect Wallet"
   - Acepta cuando la plataforma pida agregar la red Fuji
   - La red se agregará automáticamente

**Problema:** "No puedo cambiar de red en mi billetera"

**Soluciones:**
1. **Primero intenta que la plataforma lo haga automáticamente:**
   - Desconecta tu billetera
   - Reconecta haciendo clic en "Connect Wallet"
   - Acepta cuando aparezca la solicitud de cambio de red

2. **Si aparece un error al agregar la red:**
   - Verifica que todos los parámetros sean correctos:
     - Chain ID: 43113
     - RPC URL: https://api.avax-test.network/ext/bc/C/rpc
   
3. **Como último recurso:**
   - En tu billetera, elimina cualquier red Fuji existente
   - Vuelve a la plataforma y reconecta
   - Deja que la plataforma agregue la red automáticamente

### Problemas con Transacciones

**Problema:** "Transaction failed" o "Transacción fallida"

**Soluciones:**
1. **Verifica el error específico:**
   - Abre la transacción en Snowtrace
   - Lee el mensaje de error

2. **Errores comunes y soluciones:**

   **"Insufficient funds for gas":**
   - Necesitas más AVAX
   - Ve al faucet de AVAX (Paso 2)

   **"Insufficient USDC balance":**
   - Necesitas más USDC
   - Ve al faucet de USDC (Paso 3)

   **"Insufficient USDC allowance":**
   - Necesitas aprobar USDC primero
   - Haz clic en "Approve USDC Spending"

   **"Campaign is not active":**
   - La campaña terminó o está pausada
   - Espera o solicita reembolso si aplica

   **"Exceeds maximum allowed contribution":**
   - Tu contribución excede los límites anti-ballena
   - Reduce la cantidad

   **"Gas limit exceeded":**
   - La transacción es muy compleja
   - Normalmente se resuelve solo
   - Intenta de nuevo en unos minutos

3. **Pasos generales:**
   - Espera 1-2 minutos
   - Refresca la página
   - Intenta la transacción nuevamente
   - Si persiste, reporta en los canales de soporte

**Problema:** "Transaction stuck" o "Transacción atascada"

**Soluciones:**
1. Espera 5-10 minutos (a veces demora)
2. Verifica el estado en Snowtrace con el hash de transacción
3. Si está "pending" por más de 30 minutos:
   - Es muy raro en Avalanche
   - Contacta soporte con el hash de transacción

**Problema:** "Approved USDC but can't contribute"

**Soluciones:**
1. Espera 30 segundos después de la aprobación
2. Refresca la página
3. Verifica que la aprobación se confirmó (ve al explorador)
4. Intenta contribuir nuevamente

### Problemas con Balances

**Problema:** "No veo mi balance de USDC"

**Soluciones:**
1. **En la plataforma:**
   - Refresca la página
   - Desconecta y reconecta tu billetera

2. **En tu billetera:**
   - Agrega el token USDC manualmente
   - Usa la dirección del contrato (ver Paso 3)

3. **Verifica en blockchain:**
   - Ve a Snowtrace
   - Busca tu dirección
   - Verifica las transacciones
   - Confirma que recibiste el USDC

**Problema:** "No veo mis tokens de gobernanza"

**Soluciones:**
1. **En la plataforma:**
   - Ve a la página de Fundraising
   - Busca "Your Share Balance"
   - Debería aparecer después de contribuir

2. **En tu billetera:**
   - Agrega el token U-SHARE manualmente (ver Paso 5)
   - Usa la dirección del contrato de Share Tokens

3. **Verifica la transacción:**
   - Si contribuiste exitosamente, deberías tener tokens
   - Ve a Snowtrace con el hash de tu contribución
   - Verifica que la transacción fue exitosa

### Problemas con Tally

**Problema:** "Tally no reconoce mis tokens"

**Soluciones:**
1. Verifica que conectaste la misma billetera que usaste para contribuir
2. Espera unos minutos (a veces tarda en sincronizar)
3. Refresca la página de Tally
4. Desconecta y reconecta tu billetera en Tally

**Problema:** "No puedo votar en Tally"

**Soluciones:**
1. **Verifica que tengas tokens:**
   - En tu perfil de Tally
   - Debería aparecer tu balance

2. **Auto-delegación:**
   - Necesitas delegarte a ti mismo primero
   - Ve a tu perfil → Delegate → Ingresa tu dirección → Confirma

3. **Verifica la propuesta:**
   - ¿Está activa?
   - ¿No ha terminado la votación?
   - ¿Ya votaste?

**Problema:** "No puedo crear propuestas"

**Soluciones:**
1. Verifica que tienes suficientes tokens (revisa el threshold)
2. Asegúrate de estar conectado con la billetera correcta
3. Verifica que te delegaste a ti mismo

### Problemas con el Faucet

**Problema:** "El faucet no me envía AVAX"

**Soluciones:**
1. Verifica que estás usando la red Fuji
2. Espera 1-2 minutos
3. Prueba con otro faucet (ver Paso 2)
4. Intenta más tarde (algunos faucets tienen límites de tiempo)

**Problema:** "El faucet de USDC no funciona"

**Soluciones:**
1. Verifica que conectaste tu billetera
2. Asegúrate de estar en la red Fuji
3. Verifica que tienes suficiente AVAX para gas
4. Refresca la página e intenta nuevamente
5. Verifica la transacción en Snowtrace

---

## Glosario de Términos

**Blockchain:** Tecnología de base de datos distribuida donde la información se almacena en "bloques" encadenados, inmutables y transparentes.

**Smart Contract:** Programa que se ejecuta automáticamente en blockchain cuando se cumplen ciertas condiciones. No requiere intermediarios.

**Wallet/Billetera:** Software que almacena tus claves privadas y te permite interactuar con blockchain. Como tu cuenta bancaria digital.

**AVAX:** Criptomoneda nativa de Avalanche. Se usa para pagar gas fees.

**USDC:** Stablecoin vinculada al dólar estadounidense (1 USDC ≈ $1 USD). Útil para transacciones sin volatilidad.

**Gas Fee:** Tarifa que pagas por cada transacción en blockchain. Compensa a los validadores por procesar tu transacción.

**Testnet:** Red de prueba de blockchain. Usa dinero falso para que desarrolladores y usuarios practiquen sin riesgo.

**Mainnet:** Red principal de blockchain. Usa dinero real.

**Token:** Activo digital que representa algo (dinero, propiedad, acceso, etc.). En este caso, poder de voto.

**DAO:** Organización Autónoma Descentralizada. Una organización gobernada por sus miembros a través de votaciones en blockchain.

**Governance/Gobernanza:** Sistema de toma de decisiones en un DAO. Los miembros votan en propuestas.

**Proposal/Propuesta:** Sugerencia formal de acción o cambio que se somete a votación en un DAO.

**Delegate/Delegar:** Dar tu poder de voto a otra persona para que vote por ti.

**Quorum:** Número mínimo de votos necesarios para que una votación sea válida.

**Faucet:** Servicio que distribuye pequeñas cantidades de criptomonedas gratis, generalmente en testnets.

**Hash:** Código único que identifica una transacción. Como un número de seguimiento.

**Approval:** Permiso que das a un smart contract para usar tus tokens.

**Anti-Whale:** Mecanismos para evitar que grandes inversores ("ballenas") dominen un proyecto.

**Refund/Reembolso:** Devolución de fondos cuando una campaña no alcanza su objetivo.

**Explorer:** Sitio web donde puedes ver todas las transacciones públicas de blockchain (ej: Snowtrace).

**RPC:** URL que tu billetera usa para conectarse a la red blockchain.

**Chain ID:** Número único que identifica una red blockchain específica.

**ERC-20:** Estándar técnico para tokens en blockchain. Los tokens ERC-20 son compatibles con billeteras y exchanges.

---

## Recursos Adicionales

### Enlaces Oficiales

**Documentación de la Plataforma:**
- README principal: `/README.md`
- Guía técnica: `/RAINBOWKIT_WAGMI_IMPLEMENTATION_GUIDE.md`

**Avalanche:**
- Sitio oficial: [https://www.avax.network/](https://www.avax.network/)
- Documentación: [https://docs.avax.network/](https://docs.avax.network/)
- Snowtrace (Explorador): [https://testnet.snowtrace.io/](https://testnet.snowtrace.io/)

**Billeteras:**
- Core Wallet: [https://core.app/](https://core.app/)
- MetaMask: [https://metamask.io/](https://metamask.io/)

**Tally:**
- Sitio oficial: [https://www.tally.xyz/](https://www.tally.xyz/)
- Documentación: [https://docs.tally.xyz/](https://docs.tally.xyz/)
- DAO del proyecto: [https://www.tally.xyz/gov/dao-prueba-fundraising-1](https://www.tally.xyz/gov/dao-prueba-fundraising-1)

**Faucets:**
- Core Faucet: [https://core.app/tools/testnet-faucet/](https://core.app/tools/testnet-faucet/)
- Avalanche Builder Console: [https://build.avax.network/console/primary-network/faucet](https://build.avax.network/console/primary-network/faucet)

### Aprender Más

**Sobre Blockchain:**
- [Binance Academy - ¿Qué es Blockchain?](https://academy.binance.com/es/articles/what-is-blockchain-technology)
- [Avalanche Learn - Fundamentos](https://www.avax.network/learn)

**Sobre DAOs:**
- [Ethereum.org - DAOs](https://ethereum.org/es/dao/)
- [Tally - DAO Basics](https://docs.tally.xyz/)

**Sobre Gobernanza:**
- [Tally - Governance Guide](https://docs.tally.xyz/)
- [OpenZeppelin - Governance](https://docs.openzeppelin.com/contracts/governance)

### Comunidad y Soporte

**Canales de comunicación:**
(Estos serían canales específicos del proyecto)
- Discord: [Enlace al Discord del proyecto]
- Telegram: [Enlace al Telegram del proyecto]
- Twitter: [Enlace al Twitter del proyecto]
- Forum: [Enlace al foro del proyecto]

**Cómo obtener ayuda:**
1. Revisa esta guía primero
2. Busca en la sección de Preguntas Frecuentes
3. Pregunta en los canales de la comunidad
4. Reporta bugs técnicos en GitHub (si aplica)

**Buenas prácticas al pedir ayuda:**
- Describe el problema claramente
- Incluye pasos que ya intentaste
- Proporciona capturas de pantalla si es posible
- Comparte el hash de transacción si es relevante
- Sé paciente y educado

---

## Conclusión

¡Felicidades por llegar hasta aquí! Ahora tienes todo el conocimiento necesario para:

✅ Configurar tu billetera Web3
✅ Obtener fondos de testnet (AVAX y USDC)
✅ Contribuir a campañas de fundraising
✅ Recibir y gestionar tokens de gobernanza
✅ Participar activamente en el DAO con Tally
✅ Votar en propuestas y delegar tu poder de voto
✅ Entender los conceptos clave de blockchain y DAOs

### Próximos Pasos

1. **Practica en testnet:**
   - Experimenta sin miedo (no es dinero real)
   - Prueba todas las funcionalidades
   - Aprende de los errores

2. **Participa en la comunidad:**
   - Únete a los canales de comunicación
   - Conoce a otros miembros
   - Comparte tus experiencias

3. **Mantente informado:**
   - Sigue las actualizaciones del proyecto
   - Lee las propuestas en Tally
   - Participa en discusiones

4. **Aprende más:**
   - Profundiza en blockchain
   - Estudia sobre gobernanza descentralizada
   - Explora otros DAOs

### Recuerda

- 🔒 **Seguridad primero:** Nunca compartas tu frase de recuperación
- 💡 **Aprende haciendo:** La mejor forma de aprender es practicando
- 🤝 **Comunidad:** No dudes en pedir ayuda cuando la necesites
- 📊 **Participa:** Tu voz importa, especialmente en decisiones del DAO
- 🎯 **Transparencia:** Todo es público en blockchain, aprovecha esa transparencia

### Feedback

Esta guía está en constante mejora. Si encuentras:
- Errores o información desactualizada
- Secciones confusas que necesitan aclaración
- Temas que deberían agregarse
- Sugerencias de mejora

Por favor compártelo con la comunidad o el equipo del proyecto.

---

**¡Bienvenido al futuro del fundraising descentralizado!** 🚀

*Última actualización: Octubre 2025*
*Versión: 1.0*

