There are two parts of this project: the android app and the restful server. There is also a third part, the client used by the app to communicate with the server, which will be briefly mentioned at the end.

#### Android app

Built with [Dart](https://dart.dev) using the [Flutter framework](https://flutter.dev). Divided in two subprojects: one encapsulates the logic of the app (mainly state management, models and services) and has no material/flutter imports; the other contains the UI side (pages, routing and such).

State management is handled with the help of the [BLoC package](https://bloclibrary.dev). Roughly each screen is assigned one to two BLoCs (one to send the main state of the page and a second one -which is called manager- to handle and react to events from the user).

Internationalisation (i18n/l10n) is managed with the [built-in Flutter tools (flutter_localizations package)](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization).

#### Server

Built with [Rust](https://www.rust-lang.org) using the [Actix framework](https://actix.rs). It implements a RESTful API to access the database (currently only postgres supported). It also connects to an image provider to store the images (currently only cloudinary supported through the [cloudinary_client crate](https://github.com/viplmad/cloudinary_rs)).

Database access is handled through [sqlx](https://crates.io/crates/sqlx). There is no ORM, instead [serde](https://serde.rs) is used to de/serialize and [SeaQuery](https://crates.io/crates/sea-query) (a query builder library independent from [SeaORM](https://www.sea-ql.org/SeaORM)) is used to abstract the SQL query creation.

OpenAPI specification is (semi)automatically generated using the [utoipa crate](https://crates.io/crates/utoipa) and is accessible in /api-docs/ when the server is up. It can also be accessed through this docs [here](../openapi).

#### Client

Initially built from the OpenAPI specification using the [OpenAPI Generator](https://openapi-generator.tech). From that initial automatic generation some tweaks were applied. It's also updated (manually) whenever the server changes with the help of the aforementioned generator.
