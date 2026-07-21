<div align="center">
  <h1>🏢 Sistema Condominio Mobile</h1>
  <p><strong>Aplicación móvil multiplataforma para la gestión integral de condominios y residencias.</strong></p>

  <p>
    <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter">
    <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" alt="Dart">
    <img src="https://img.shields.io/badge/Riverpod-State_Management-1A2B3C?logo=dart&logoColor=white" alt="Riverpod">
    <img src="https://img.shields.io/badge/Plataforma-Android%20%7C%20iOS-4CAF50?logo=android&logoColor=white" alt="Platform">
  </p>
</div>

---

## 📖 Acerca del Proyecto

**Sistema Condominio Mobile** es el cliente móvil oficial diseñado para ofrecer a los administradores una herramienta rápida, moderna y portátil para la gestión de su condominio. Desarrollada con **Flutter** bajo un enfoque de alto rendimiento, la aplicación mantiene **paridad funcional exacta** con los clientes Web y Desktop, consumiendo la misma API centralizada (Spring Boot + PostgreSQL).

El objetivo es proveer una experiencia fluida, reactiva y segura que permita gestionar residentes, propiedades, finanzas y comunicados directamente desde el bolsillo.

## ✨ Características Principales

*   📊 **Dashboard Interactivo:** Resumen en tiempo real del estado del condominio, métricas de recaudación, morosidad y ocupación.
*   👥 **Gestión de Residentes:** Registro, edición y control de estado (`ACTIVO` / `INACTIVO`) de los inquilinos y dueños.
*   🏠 **Control de Residencias:** Asignación de propiedades a residentes activos, control de cuotas mensuales base y estados de ocupación.
*   💰 **Finanzas y Cuotas:** Generación rápida de obligaciones financieras recurrentes para periodos autorizados (Ej. 2026 en adelante).
*   📢 **Comunicados:** Creación y emisión de boletines informativos. Soporta notificaciones de tipo `GENERAL` para toda la comunidad o `INDIVIDUAL` seleccionando residentes específicos con distintos niveles de urgencia (Alta, Normal, Baja).

## 🛠️ Stack Tecnológico

*   **Framework:** [Flutter](https://flutter.dev/) (SDK multiplataforma)
*   **Lenguaje:** [Dart](https://dart.dev/)
*   **Gestión de Estado:** [Riverpod](https://riverpod.dev/) (Implementación asíncrona robusta y segura)
*   **Cliente HTTP:** [Dio](https://pub.dev/packages/dio) (Intercepción de peticiones y seguridad JWT)
*   **Arquitectura:** Feature-First / Clean Architecture (Divisiones lógicas por módulo y responsabilidades claras: `data`, `domain`, `presentation`).

## ⚙️ Arquitectura y Estructura

El proyecto está organizado siguiendo el patrón **Feature-First**. Esto permite una fácil escalabilidad y desacoplamiento de las lógicas de negocio:

```text
lib/
├── core/                   # Configuraciones globales, UI base, networking y theme
├── features/               # Módulos principales de la aplicación
│   ├── auth/               # Autenticación y gestión de tokens JWT
│   ├── comunicados/        # Bandeja y emisión de comunicados
│   ├── dashboard/          # Métricas y visualización
│   ├── pagos/              # Panel enfocado a la generación de Cuotas
│   ├── residencias/        # Gestión de bienes raíces e inmuebles
│   └── residentes/         # Perfiles y estados de residentes
└── main.dart               # Punto de entrada de la aplicación
```

## 🚀 Instalación y Despliegue

### Requisitos Previos

- Flutter SDK `^3.0.0` o superior.
- Dart SDK `^3.0.0` o superior.
- Dispositivo físico o Emulador de Android/iOS configurado.
- (Opcional) Acceso a la API del backend en Spring Boot (`sistema-condominio-api`).

### Pasos de Instalación

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/XavierAltamiranoPineda/sistema-condominio-mobile.git
   cd sistema-condominio-mobile
   ```

2. **Obtener dependencias:**
   ```bash
   flutter pub get
   ```

3. **Configurar el endpoint (Backend):**
   Asegúrate de que la URL de la API en el cliente HTTP (`lib/core/constants/constants.dart` o equivalente) apunte correctamente al servidor en Railway o a tu `localhost`.

4. **Ejecutar en modo Debug:**
   ```bash
   flutter run
   ```

5. **Construir el APK de Producción (Android):**
   ```bash
   flutter build apk --release
   ```
   El archivo generado se ubicará en `build/app/outputs/flutter-apk/app-release.apk`.

## 🔒 Reglas de Negocio & Paridad

Este cliente ha sido auditado para asegurar consistencia bidireccional con el Backend y los demás clientes (Web/Desktop):
*   Los residentes con estado `INACTIVO` no pueden ser asignados como propietarios de una nueva residencia.
*   Los comunicados enviados son **inmutables** por seguridad e integridad de la información (no admiten edición).
*   La generación de cuotas está sujeta a controles estrictos de temporalidad.

---
*Construido para brindar eficiencia y control a la palma de tu mano.* 📱
