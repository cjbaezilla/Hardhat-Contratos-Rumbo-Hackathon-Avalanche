# Contrato Inteligente FundraisingCampaign - Guía Completa del Usuario

## ¿Qué es Este Contrato?

El contrato FundraisingCampaign es una plataforma de crowdfunding descentralizada construida en Avalanche que permite a las personas recaudar dinero para proyectos, causas o negocios. Piensa en él como una versión de Kickstarter o GoFundMe impulsada por blockchain, pero con características únicas que lo hacen más seguro y transparente.

Cuando alguien crea una campaña, establece una meta de financiamiento y una fecha límite. Las personas pueden contribuir con USDC (una criptomoneda estable vinculada al dólar estadounidense) para apoyar la campaña. A cambio, los contribuyentes reciben tokens especiales que representan su participación en el proyecto **y les dan poder de voto en la DAO resultante**. Si la campaña alcanza su meta, el creador obtiene los fondos y se forma una organización autónoma descentralizada donde todos los contribuyentes pueden participar en decisiones de gobernanza. Si no, los contribuyentes pueden recuperar su dinero.

**La innovación clave**: Esto no es solo crowdfunding - es gobernanza impulsada por la comunidad. Cada contribuyente se convierte en un stakeholder con derechos de voto en la dirección futura del proyecto.

## Características Clave que lo Hacen Especial

### 1. **Protección Anti-Ballena**
Esto no es solo un término elegante - es un mecanismo de protección real. Imagina si un multimillonario pudiera entrar y comprar el 90% de tu campaña de una vez, dejando poco espacio para los partidarios regulares. El contrato previene esto estableciendo límites sobre cuánto puede contribuir cualquier persona individual.

### 2. **Tokenización de Participaciones con Gobernanza DAO**
Cuando contribuyes a una campaña, no solo regalas dinero. Recibes tokens que representan tu participación en el proyecto y **poder de voto dentro de la DAO**. Estos tokens te dan el derecho de participar en decisiones de gobernanza sobre la dirección del proyecto, asignación de fondos y elecciones estratégicas. Tus tokens literalmente representan tu voz en la organización autónoma descentralizada que se forma alrededor de las campañas exitosas.

### 3. **Sistema de Reembolso Automático**
Si una campaña no alcanza su meta para la fecha límite, los contribuyentes pueden recuperar automáticamente su dinero. No necesitas confiar en que el creador de la campaña devuelva los fondos - el contrato inteligente se encarga de ello.

### 4. **Transparente e Inmutable**
Todas las transacciones se registran en la blockchain, por lo que puedes ver exactamente a dónde va tu dinero y cómo progresa la campaña. Una vez que algo se registra, no puede cambiarse u ocultarse.

## Cómo Funcionan las Campañas

### Crear una Campaña

Cuando alguien quiere iniciar una campaña de recaudación de fondos, necesita proporcionar varias piezas de información:

- **Título y Descripción**: De qué trata la campaña
- **Monto de la Meta**: Cuánto dinero quieren recaudar (en USDC)
- **Duración**: Cuánto tiempo durará la campaña
- **Monto Máximo de Contribución**: Lo máximo que cualquier persona individual puede contribuir
- **Porcentaje Máximo de Contribución**: Qué porcentaje de la meta total puede contribuir cualquier persona individual

El creador también necesita tener tokens USDC para interactuar con el contrato, y se convierte en el propietario de la campaña.

### El Ciclo de Vida de la Campaña

#### Fase 1: Recaudación Activa
Durante esta fase, cualquiera puede contribuir USDC a la campaña. Esto es lo que sucede cuando alguien hace una contribución:

1. **Verificaciones de Validación**: El contrato verifica que:
   - El contribuyente tiene suficiente USDC en su billetera
   - Ha dado permiso para que el contrato gaste su USDC
   - Su contribución no excede los límites máximos
   - La campaña sigue activa y no ha pasado su fecha límite

2. **Acuñación de Tokens**: Si todo está en orden, el contrato:
   - Transfiere USDC del contribuyente a la campaña
   - Acuña tokens de participación iguales al monto de la contribución
   - Registra la contribución en el historial de la campaña
   - Actualiza el monto total recaudado

3. **Finalización Automática**: Si la contribución empuja el total por encima del monto de la meta, la campaña se completa automáticamente con éxito.

#### Fase 2: Finalización de la Campaña
Hay tres formas en que una campaña puede terminar:

**Éxito (Meta Alcanzada)**
- El creador de la campaña puede retirar todos los fondos
- Los contribuyentes mantienen sus tokens de participación **y derechos de voto DAO**
- Se forma una DAO con todos los poseedores de tokens como miembros
- La campaña se marca como completada

**Fracaso (Meta No Alcanzada para la Fecha Límite)**
- Los contribuyentes pueden solicitar reembolsos de su USDC
- Sus tokens de participación se queman (destruyen)
- El creador de la campaña también puede retirar cualquier fondo parcial a través del retiro de emergencia

**Retiro de Emergencia**
- Si pasa la fecha límite y la meta no se alcanzó, el creador puede retirar los fondos que se recaudaron
- Esto es útil para campañas que recaudaron dinero significativo pero no alcanzaron su objetivo

## Entendiendo el Mecanismo Anti-Ballena

El sistema anti-ballena funciona en dos niveles:

### Monto Máximo de Contribución
Este es un límite estricto sobre cuánto puede contribuir cualquier persona individual en una transacción. Por ejemplo, si esto se establece en $10,000, nadie puede contribuir más de $10,000 a la vez.

### Porcentaje Máximo de Contribución
Esto limita cuánto de la meta total puede contribuir cualquier persona individual. Si la meta es $100,000 y el porcentaje máximo es 10%, entonces ninguna persona individual puede contribuir más de $10,000 en total, incluso a través de múltiples transacciones.

### Por Qué Esto Importa
Sin estas protecciones, una persona adinerada podría:
- Dominar una campaña contribuyendo la mayor parte de la meta
- Prevenir que los partidarios regulares participen
- Potencialmente manipular el resultado de la campaña

Los límites aseguran que las campañas permanezcan accesibles para una amplia comunidad de partidarios.

## Tokens de Participación Explicados - Tu Poder de Voto DAO

Cuando contribuyes a una campaña, recibes "User Shares Tokens" (userSHARE). Estos tokens son mucho más que simples recibos - son tus **tokens de gobernanza para la DAO**:

- **Representan Tu Participación**: Cada token representa $1 USDC que contribuiste
- **Poder de Voto DAO**: Tus tokens te dan derechos de voto en la organización autónoma descentralizada
- **Participación en Gobernanza**: Vota sobre decisiones del proyecto, asignación de fondos, asociaciones y dirección estratégica
- **Influencia Proporcional**: Mientras más contribuyas, más poder de voto tienes en la DAO
- **Son Transferibles**: Puedes enviarlos a otras personas, transfiriendo tus derechos de voto
- **Construidos para Gobernanza**: Los tokens usan el estándar ERC20Votes, diseñado específicamente para gobernanza DAO
- **Pueden Ser Quemados**: Si obtienes un reembolso, tus tokens y derechos de voto se destruyen

Los tokens están construidos usando múltiples estándares de Ethereum incluyendo **ERC20Votes**, que está diseñado específicamente para sistemas de gobernanza descentralizada. Esto los hace compatibles con varias plataformas DAO y mecanismos de votación.

## Características de Seguridad

### Protección Contra Reentrada
Esto previene que contratos maliciosos llamen a la función de contribución múltiples veces en una sola transacción, lo que podría drenar fondos.

### Transferencias Seguras de Tokens
El contrato usa la biblioteca SafeERC20 de OpenZeppelin, que proporciona verificaciones de seguridad adicionales para las transferencias de tokens y previene vulnerabilidades comunes relacionadas con tokens.

### Protección Contra Desbordamiento
Todas las operaciones matemáticas incluyen verificaciones para prevenir desbordamiento de enteros, lo que podría causar comportamiento inesperado o pérdida de fondos.

### Control de Acceso
Solo el creador de la campaña puede realizar ciertas acciones como retirar fondos o actualizar parámetros de la campaña. Esto previene el acceso no autorizado a las funciones de la campaña.

## Cómo Usar el Contrato

### Para Contribuyentes

1. **Verificar Detalles de la Campaña**: Revisa la meta, fecha límite y progreso actual
2. **Calcular Tu Contribución Máxima**: Usa la función `getMaxAllowedContribution` para ver cuánto puedes contribuir
3. **Aprobar el Gasto de USDC**: Da al contrato permiso para gastar tu USDC
4. **Hacer Tu Contribución**: Llama a la función `contribute` con tu monto deseado
5. **Recibir Tokens de Participación**: Tus tokens serán acuñados automáticamente a tu billetera

### Para Creadores de Campañas

1. **Crear Tu Campaña**: Despliega el contrato con los parámetros de tu campaña
2. **Monitorear el Progreso**: Revisa las contribuciones y el estado de la campaña regularmente
3. **Actualizar Parámetros**: Ajusta la fecha límite, monto de la meta o límites de contribución según sea necesario
4. **Retirar Fondos**: Una vez que se alcance la meta, llama a `withdrawFunds`
5. **Manejar Reembolsos**: Si la campaña falla, los contribuyentes pueden solicitar reembolsos
6. **Verificación Manual de Fecha Límite**: Usa `checkDeadlineAndComplete()` para verificar manualmente el estado de la campaña

## Características Avanzadas

### Actualizaciones de Campaña
Los creadores pueden actualizar ciertos parámetros durante la campaña:
- **Fecha Límite**: Extender o acortar la duración de la campaña usando `updateDeadline()`
- **Monto de la Meta**: Ajustar el objetivo de financiamiento usando `updateGoalAmount()`
- **Límites de Contribución**: Modificar los parámetros anti-ballena usando `updateMaxContributionAmount()` y `updateMaxContributionPercentage()`
- **Verificación de Fecha Límite**: Activar manualmente las verificaciones de fecha límite usando `checkDeadlineAndComplete()`

### Ver Datos de la Campaña
El contrato proporciona varias funciones para ver información de la campaña:
- **Estadísticas de la Campaña**: Meta, monto actual, fecha límite, estado usando `getCampaignStats()`
- **Contribuciones**: Lista completa de todas las contribuciones usando `getCampaignContributions()`
- **Saldos de Usuario**: Cuánto ha contribuido cada persona usando `getContributorAmount()`
- **Saldos de Participación**: Cuántos tokens de participación tiene cada persona usando `getUserShareBalance()`
- **Parámetros Anti-Ballena**: Límites actuales usando `getAntiWhaleParameters()`
- **Contribución Máxima Permitida**: Calcular límites para usuarios específicos usando `getMaxAllowedContribution()`
- **Información de Tokens**: Dirección del token de participación y suministro total usando `getSharesTokenAddress()` y `getTotalSharesSupply()`

### Funciones Administrativas Avanzadas

#### Actualización de Parámetros de Campaña
Los creadores de campañas tienen acceso a varias funciones administrativas para gestionar sus campañas:

**`updateDeadline(uint256 newDeadline)`**
- Permite a los creadores extender o modificar la fecha límite de la campaña
- La nueva fecha límite debe estar en el futuro y ser diferente a la fecha límite actual
- Solo puede ser llamada por el creador de la campaña
- La campaña no debe estar completada

**`updateGoalAmount(uint256 newGoalAmount)`**
- Permite a los creadores ajustar el objetivo de financiamiento
- El nuevo objetivo debe ser mayor que 0 y diferente al objetivo actual
- Si el nuevo objetivo es menor que el monto actual, la campaña se completa automáticamente
- Solo puede ser llamada por el creador de la campaña

**`updateMaxContributionAmount(uint256 newMaxAmount)`**
- Modifica el monto máximo que cualquier persona individual puede contribuir
- El nuevo monto debe ser mayor que 0 y diferente al límite actual
- Ayuda a mantener la protección anti-ballena

**`updateMaxContributionPercentage(uint256 newMaxPercentage)`**
- Ajusta el porcentaje máximo del objetivo que cualquier persona individual puede contribuir
- Debe estar entre 1 y 10000 puntos base (0.01% a 100%)
- Diferente al porcentaje actual

**`checkDeadlineAndComplete()`**
- Activa manualmente la verificación de fecha límite y finalización de campaña
- Puede ser llamada por cualquier persona para asegurar que el estado de la campaña esté actualizado
- Útil para asegurar un estado preciso de la campaña

## Escenarios Comunes

### Escenario 1: Campaña Exitosa
1. La campaña alcanza su meta de $50,000
2. El creador retira todos los fondos
3. Los contribuyentes mantienen sus tokens de participación y derechos de voto DAO
4. Se forma automáticamente una DAO con todos los poseedores de tokens como miembros votantes
5. Los poseedores de tokens ahora pueden votar sobre decisiones de gobernanza del proyecto
6. La campaña se marca como completada

### Escenario 2: Campaña Fallida
1. La fecha límite de la campaña pasa con solo $30,000 recaudados de una meta de $50,000
2. Los contribuyentes solicitan reembolsos y recuperan su USDC
3. Los tokens de participación se queman
4. El creador puede retirar los fondos restantes a través del retiro de emergencia

### Escenario 3: Contribuyente Grande
1. Alguien trata de contribuir $15,000 a una campaña con un límite máximo de $10,000
2. La transacción falla con un mensaje de error
3. Deben contribuir $10,000 o menos

## Mejores Prácticas

### Para Contribuyentes
- **Investigar la Campaña**: Asegúrate de entender lo que estás apoyando y la estructura de gobernanza DAO
- **Verificar Límites**: Verifica cuánto puedes contribuir antes de intentar
- **Mantener Registros**: Guarda los hashes de transacción para tus registros
- **Monitorear el Progreso**: Verifica si la campaña alcanza su meta
- **Entender Tus Derechos de Voto**: Sabe que tus tokens te dan poder de gobernanza DAO

### Para Creadores de Campañas
- **Establecer Metas Realistas**: No establezcas metas demasiado altas o bajas
- **Proporcionar Actualizaciones**: Mantén informados a los contribuyentes sobre el progreso
- **Respetar Fechas Límite**: No extiendas las fechas límite innecesariamente
- **Planificar para el Éxito**: Ten un plan para lo que sucede cuando alcances tu meta
- **Monitorear Parámetros Anti-Ballena**: Revisa y ajusta regularmente los límites de contribución según sea necesario
- **Usar Funciones Administrativas**: Aprovecha `updateDeadline()`, `updateGoalAmount()` y las funciones de límites para optimizar el rendimiento de la campaña
- **Verificar Estado de la Campaña**: Usa `checkDeadlineAndComplete()` para asegurar un estado preciso de la campaña

## Requisitos Técnicos

### Para Contribuyentes
- **Tokens USDC**: Necesitas USDC en tu billetera
- **Tarifas de Gas**: Necesitarás AVAX para las tarifas de transacción
- **Conexión de Billetera**: Conecta tu billetera para interactuar con el contrato

### Para Creadores de Campañas
- **Configuración Inicial**: Despliega el contrato con parámetros apropiados
- **Aprobación de USDC**: Aprueba el contrato para gastar USDC
- **Gestión Activa**: Monitorea y gestiona la campaña

## Solución de Problemas Comunes

### "Saldo de USDC Insuficiente"
No tienes suficiente USDC en tu billetera. Compra más USDC o reduce tu monto de contribución.

### "Permiso de USDC Insuficiente"
No has dado al contrato permiso para gastar tu USDC. Aprueba el contrato para gastar el monto que quieres contribuir.

### "La contribución excede el monto máximo permitido"
Tu contribución es demasiado grande. Verifica los límites máximos de contribución y reduce tu monto.

### "La campaña no está activa"
La campaña ha terminado, ha sido pausada o completada. Verifica el estado de la campaña.

### "La fecha límite de la campaña no se ha alcanzado"
Estás tratando de solicitar un reembolso antes de la fecha límite. Espera hasta que pase la fecha límite.

## Conclusión

El contrato FundraisingCampaign representa un avance significativo en la recaudación de fondos descentralizada. Al combinar conceptos tradicionales de crowdfunding con tecnología blockchain, crea una plataforma más transparente, segura y justa para recaudar fondos.

Los mecanismos anti-ballena aseguran que las campañas permanezcan accesibles para todos, mientras que el sistema de tokenización de participaciones da a los contribuyentes una participación real en los proyectos que apoyan **y poder de voto en la DAO resultante**. El sistema de reembolso automático protege a los contribuyentes, mientras que las herramientas flexibles de gestión de campañas dan a los creadores el control que necesitan para ejecutar campañas exitosas. Lo más importante, las campañas exitosas se transforman automáticamente en organizaciones autónomas descentralizadas donde todos los contribuyentes tienen voz en la gobernanza.

Ya sea que estés buscando apoyar una causa en la que crees o recaudar fondos para tu propio proyecto, este contrato proporciona una base sólida para la recaudación de fondos descentralizada que devuelve el poder a las manos de la comunidad.

Recuerda, este es un contrato inteligente en la blockchain, lo que significa que es transparente, inmutable y opera sin intermediarios. Tus contribuciones están seguras, tus tokens de participación son tuyos para mantener (junto con tus derechos de voto DAO), y el progreso de la campaña siempre es visible para todos.

El futuro de la recaudación de fondos está aquí, y está construido sobre confianza, transparencia, participación comunitaria **y gobernanza descentralizada a través de DAOs**.
