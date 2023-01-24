import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/model/model.dart' show ServerConnection;
import 'package:backend/service/service.dart' show GameCollectionService;
import 'package:backend/bloc/server_settings/server_settings.dart';
import 'package:backend/bloc/server_settings_manager/server_settings_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/show_snackbar.dart';
import '../utils/fab_utils.dart';
import '../route_constants.dart';

class ServerConnectionFormData {
  ServerConnectionFormData()
      : name = '',
        host = '',
        username = '',
        password = '';
  String name;
  String host;
  String username;
  String password;
}

class ServerSettings extends StatelessWidget {
  const ServerSettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameCollectionService collectionService =
        RepositoryProvider.of<GameCollectionService>(context);

    final ServerSettingsManagerBloc managerBloc = ServerSettingsManagerBloc(
      collectionService: collectionService,
    );

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final ServerConnectionFormData formData = ServerConnectionFormData();

    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object?>>>[
        BlocProvider<ServerSettingsBloc>(
          create: (BuildContext context) {
            return ServerSettingsBloc(
              managerBloc: managerBloc,
            )..add(LoadServerSettings());
          },
        ),
        BlocProvider<ServerSettingsManagerBloc>(
          create: (BuildContext context) {
            return managerBloc;
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            GameCollectionLocalisations.of(context).repositorySettingsString,
          ),
          // No elevation so background color is not affected by theme
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
        ),
        body: _ServerSettingsBody(
          formKey: formKey,
          formData: formData,
        ),
        floatingActionButton:
            BlocBuilder<ServerSettingsBloc, ServerSettingsState>(
          builder: (BuildContext context, ServerSettingsState state) {
            final bool loaded = state is ServerSettingsLoaded;

            return FloatingActionButton.extended(
              label:
                  Text(GameCollectionLocalisations.of(context).connectString),
              icon: const Icon(Icons.send),
              tooltip: GameCollectionLocalisations.of(context).connectString,
              onPressed: loaded
                  ? () {
                      // TODO subscribe to changes if possible
                      if (formKey.currentState != null &&
                          formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        managerBloc.add(
                          SaveServerConnectionSettings(
                            formData.name,
                            formData.host,
                            formData.username,
                            formData.password,
                          ),
                        );
                      }
                    }
                  : null,
              foregroundColor: Colors.white,
              backgroundColor: FABUtils.backgroundIfActive(
                // TODO check this
                enabled: loaded,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ServerSettingsBody extends StatelessWidget {
  const _ServerSettingsBody({
    Key? key,
    required this.formKey,
    required this.formData,
  }) : super(key: key);

  final Key formKey;
  final ServerConnectionFormData formData;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServerSettingsManagerBloc, ServerSettingsManagerState>(
      listener: (BuildContext context, ServerSettingsManagerState state) async {
        if (state is ServerConnectionSettingsSaved) {
          final String message = GameCollectionLocalisations.of(context)
              .updatedItemConnectionString;
          showSnackBar(context, message: message);

          // When correctly saved -> navigate to connect page
          Navigator.pushReplacementNamed(
            context,
            connectRoute,
          );
        }
        if (state is ServerSettingsNotSaved) {
          final String message = GameCollectionLocalisations.of(context)
              .unableToUpdateConnectionString;
          showSnackBar(
            context,
            message: message,
            snackBarAction: dialogSnackBarAction(
              context,
              label: GameCollectionLocalisations.of(context).moreString,
              title: message,
              content: state.error,
            ),
          );
        }
        if (state is ServerSettingsNotLoaded) {
          final String message = GameCollectionLocalisations.of(context)
              .unableToLoadConnectionString;
          showSnackBar(
            context,
            message: message,
            snackBarAction: dialogSnackBarAction(
              context,
              label: GameCollectionLocalisations.of(context).moreString,
              title: message,
              content: state.error,
            ),
          );
        }
      },
      child: BlocBuilder<ServerSettingsBloc, ServerSettingsState>(
        builder: (BuildContext context, ServerSettingsState state) {
          if (state is ServerSettingsLoaded) {
            final ServerConnection? connection = state.activeServerConnection;

            final List<Widget> children = <Widget>[
              ServerConnectionForm(
                formKey: formKey,
                formData: formData,
                connection: connection,
              ),
            ];
            if (connection != null) {
              final String accessToken = connection.tokenResponse.accessToken;

              children.addAll(<Widget>[
                const Divider(),
                ListTile(
                  title: Text(
                    GameCollectionLocalisations.of(context)
                        .currentAccessTokenString,
                  ),
                  subtitle: Text(accessToken),
                  trailing: IconButton(
                    icon: const Icon(Icons.content_copy),
                    onPressed: () async {
                      Clipboard.setData(
                        ClipboardData(text: accessToken),
                      ).then(
                        (_) => showSnackBar(
                          context,
                          message: GameCollectionLocalisations.of(context)
                              .accessTokenCopied,
                        ),
                      );
                    },
                  ),
                )
              ]);
            }

            return Column(
              children: children,
            );
          }
          if (state is ServerSettingsError) {
            return Container();
          }

          return const LinearProgressIndicator();
        },
      ),
    );
  }
}

class ServerConnectionForm extends _TextForm {
  const ServerConnectionForm({
    Key? key,
    required this.formKey,
    required this.formData,
    required this.connection,
  }) : super(key: key);

  final Key formKey;
  final ServerConnectionFormData formData;
  final ServerConnection? connection;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          textFormField(
            labelText: GameCollectionLocalisations.of(context).nameString,
            initialValue: connection?.name,
            onSaved: (String? value) {
              formData.name = value ?? formData.name;
            },
          ),
          textFormField(
            labelText: GameCollectionLocalisations.of(context).hostString,
            initialValue: connection?.host,
            onSaved: (String? value) {
              formData.host = value ?? formData.host;
            },
          ),
          textFormField(
            labelText: GameCollectionLocalisations.of(context).usernameString,
            initialValue: connection?.username,
            onSaved: (String? value) {
              formData.username = value ?? formData.username;
            },
          ),
          textFormField(
            labelText: GameCollectionLocalisations.of(context).passwordString,
            initialValue: '', // Password is never saved
            obscureText: true,
            onSaved: (String? value) {
              formData.password = value ?? formData.password;
            },
          ),
        ],
      ),
    );
  }
}

abstract class _TextForm extends StatelessWidget {
  const _TextForm({
    Key? key,
  }) : super(key: key);

  Widget textFormField({
    required String labelText,
    required String? initialValue,
    bool obscureText = false,
    required void Function(String?) onSaved,
  }) {
    return _ShowHideTextFormField(
      labelText: labelText,
      initialValue: initialValue ?? '',
      allowObscureText: obscureText,
      onSaved: onSaved,
      keyboardType: TextInputType.text,
    );
  }

  Widget numberFormField({
    required String labelText,
    required int? initialValue,
    bool obscureText = false,
    required void Function(String?) onSaved,
  }) {
    return _ShowHideTextFormField(
      labelText: labelText,
      initialValue: initialValue?.toString() ?? '',
      allowObscureText: obscureText,
      onSaved: onSaved,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}

class _ShowHideTextFormField extends StatefulWidget {
  const _ShowHideTextFormField({
    Key? key,
    required this.labelText,
    required this.initialValue,
    this.allowObscureText = false,
    required this.onSaved,
    this.keyboardType,
    this.inputFormatters,
  }) : super(key: key);

  final String initialValue;
  final String labelText;
  final bool allowObscureText;
  final void Function(String?) onSaved;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<_ShowHideTextFormField> createState() => _ShowHideTextFormFieldState();
}

class _ShowHideTextFormFieldState extends State<_ShowHideTextFormField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, top: 4.0, right: 8.0, bottom: 4.0),
      child: TextFormField(
        initialValue: widget.initialValue,
        obscureText: widget.allowObscureText ? obscureText : false,
        maxLines: 1,
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: const OutlineInputBorder(),
          suffixIcon: widget.allowObscureText
              ? IconButton(
                  tooltip: obscureText
                      ? GameCollectionLocalisations.of(context).showString
                      : GameCollectionLocalisations.of(context).hideString,
                  icon: obscureText
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                )
              : null,
        ),
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        validator: (String? value) {
          if (value!.isEmpty) {
            return GameCollectionLocalisations.of(context).enterTextString;
          }
          return null;
        },
        onSaved: widget.onSaved,
      ),
    );
  }
}
