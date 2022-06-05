import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/connector/connector.dart'
    show
        CloudinaryCredentials,
        CloudinaryInstance,
        PostgresCredentials,
        PostgresInstance;

import 'package:backend/model/repository_type.dart';

import 'package:backend/bloc/repository_settings/repository_settings.dart';
import 'package:backend/bloc/repository_settings_detail/repository_settings_detail.dart';
import 'package:backend/bloc/repository_settings_manager/repository_settings_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/show_snackbar.dart';
import '../utils/fab_utils.dart';
import '../common/tabs_delegate.dart';
import '../route_constants.dart';

class RepositorySettings extends StatelessWidget {
  const RepositorySettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RepositorySettingsManagerBloc managerBloc =
        RepositorySettingsManagerBloc();

    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object?>>>[
        BlocProvider<RepositorySettingsBloc>(
          create: (BuildContext context) {
            return RepositorySettingsBloc(
              managerBloc: managerBloc,
            )..add(LoadRepositorySettings());
          },
        ),
        BlocProvider<RepositorySettingsManagerBloc>(
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
        body: const _RepositorySettingsBody(),
        floatingActionButton:
            BlocBuilder<RepositorySettingsBloc, RepositorySettingsState>(
          builder: (BuildContext context, RepositorySettingsState state) {
            bool active = false;
            if (state is RepositorySettingsLoaded) {
              active = state.ready;
            }

            return FloatingActionButton.extended(
              label:
                  Text(GameCollectionLocalisations.of(context).connectString),
              icon: const Icon(Icons.send),
              tooltip: GameCollectionLocalisations.of(context).connectString,
              onPressed: active
                  ? () {
                      Navigator.pushReplacementNamed(
                        context,
                        connectRoute,
                      );
                    }
                  : null,
              foregroundColor: Colors.white,
              backgroundColor: FABUtils.backgroundIfActive(enabled: active),
            );
          },
        ),
      ),
    );
  }
}

class _RepositorySettingsBody extends StatelessWidget {
  const _RepositorySettingsBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<RepositorySettingsManagerBloc,
        RepositorySettingsManagerState>(
      listener: (BuildContext context, RepositorySettingsManagerState state) {
        if (state is ItemConnectionSettingsUpdated) {
          final String message = GameCollectionLocalisations.of(context)
              .updatedItemConnectionString;
          showSnackBar(context, message: message);
        }
        if (state is ImageConnectionSettingsUpdated) {
          final String message = GameCollectionLocalisations.of(context)
              .updatedImageConnectionString;
          showSnackBar(context, message: message);
        }
        if (state is RepositorySettingsNotUpdated) {
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
        if (state is ItemConnectionSettingsDeleted) {
          final String message = GameCollectionLocalisations.of(context)
              .deletedItemConnectionString;
          showSnackBar(context, message: message);
        }
        if (state is ImageConnectionSettingsDeleted) {
          final String message = GameCollectionLocalisations.of(context)
              .deletedImageConnectionString;
          showSnackBar(context, message: message);
        }
        if (state is RepositorySettingsNotDeleted) {
          final String message = GameCollectionLocalisations.of(context)
              .unableToDeleteConnectionString;
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
      child: BlocBuilder<RepositorySettingsBloc, RepositorySettingsState>(
        builder: (BuildContext context, RepositorySettingsState state) {
          if (state is RepositorySettingsLoaded) {
            final ItemConnectorType? itemRadioGroup =
                state.activeItemConnection;
            final ImageConnectorType? imageRadioGroup =
                state.activeImageConnection;

            final List<String> tabTitles = <String>[
              GameCollectionLocalisations.of(context).itemConnectionString,
              GameCollectionLocalisations.of(context).imageConnectionString,
            ];

            return DefaultTabController(
              length: tabTitles.length,
              child: Builder(
                builder: (BuildContext context) {
                  return NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverPersistentHeader(
                          pinned: true,
                          floating: true,
                          delegate: TabsDelegate(
                            tabBar: TabBar(
                              tabs: tabTitles.map<Tab>((String title) {
                                return Tab(
                                  text: title,
                                );
                              }).toList(growable: false),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: <Widget>[
                        _itemRadioList(context, itemRadioGroup),
                        _imageRadioList(context, imageRadioGroup),
                      ],
                    ),
                  );
                },
              ),
            );
          }
          if (state is RepositorySettingsNotLoaded) {
            return Center(
              child: Text(state.error),
            );
          }

          return const LinearProgressIndicator();
        },
      ),
    );
  }

  Widget _itemRadioList(BuildContext context, ItemConnectorType? radioGroup) {
    return Column(
      children: <Widget>[
        _postgresRadio(context, radioGroup),
        _localItemRadio(context, radioGroup),
      ],
    );
  }

  Widget _imageRadioList(BuildContext context, ImageConnectorType? radioGroup) {
    return Column(
      children: <Widget>[
        _cloudinaryRadio(context, radioGroup),
        _localImageRadio(context, radioGroup),
      ],
    );
  }

  RadioListTile<ItemConnectorType> _postgresRadio(
    BuildContext context,
    ItemConnectorType? radioGroup,
  ) {
    return RadioListTile<ItemConnectorType>(
      title: const Text(GameCollectionLocalisations.postgresString),
      groupValue: radioGroup,
      value: ItemConnectorType.postgres,
      onChanged: (_) {
        _showPostgresDialog(context);
      },
      secondary: radioGroup == ItemConnectorType.postgres
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: <IconButton>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showPostgresDialog(context);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    BlocProvider.of<RepositorySettingsManagerBloc>(context).add(
                      DeleteItemConnectionSettings(),
                    );
                  },
                ),
              ],
            )
          : null,
    );
  }

  void _showPostgresDialog(BuildContext context) {
    showDialog<PostgresInstance>(
      context: context,
      builder: (BuildContext context) {
        final RepositorySettingsDetailBloc detailBloc =
            RepositorySettingsDetailBloc();

        return BlocBuilder<RepositorySettingsDetailBloc,
            RepositorySettingsDetailState>(
          bloc: detailBloc
            ..add(const LoadItemSettingsDetail(ItemConnectorType.postgres)),
          builder: (BuildContext context, RepositorySettingsDetailState state) {
            if (state is RepositorySettingsDetailLoaded) {
              return PostgresTextDialog(
                instance: state.instance as PostgresInstance?,
              );
            }

            return const Dialog(child: CircularProgressIndicator());
          },
        );
      },
    ).then((PostgresInstance? instance) {
      if (instance != null) {
        BlocProvider.of<RepositorySettingsManagerBloc>(context).add(
          UpdateItemConnectionSettings(ItemConnectorType.postgres, instance),
        );
      }
    });
  }

  RadioListTile<ItemConnectorType> _localItemRadio(
    BuildContext context,
    ItemConnectorType? radioGroup,
  ) {
    return RadioListTile<ItemConnectorType>(
      title: Text(GameCollectionLocalisations.of(context).localString),
      groupValue: radioGroup,
      value: ItemConnectorType.local,
      onChanged: null,
    );
  }

  RadioListTile<ImageConnectorType> _cloudinaryRadio(
    BuildContext context,
    ImageConnectorType? radioGroup,
  ) {
    return RadioListTile<ImageConnectorType>(
      title: const Text(GameCollectionLocalisations.cloudinaryString),
      groupValue: radioGroup,
      value: ImageConnectorType.cloudinary,
      onChanged: (_) {
        _showCloudinaryDialog(context);
      },
      secondary: radioGroup == ImageConnectorType.cloudinary
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: <IconButton>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showCloudinaryDialog(context);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    BlocProvider.of<RepositorySettingsManagerBloc>(context).add(
                      DeleteImageConnectionSettings(),
                    );
                  },
                ),
              ],
            )
          : null,
    );
  }

  void _showCloudinaryDialog(BuildContext context) {
    showDialog<CloudinaryInstance>(
      context: context,
      builder: (BuildContext context) {
        final RepositorySettingsDetailBloc detailBloc =
            RepositorySettingsDetailBloc();

        return BlocBuilder<RepositorySettingsDetailBloc,
            RepositorySettingsDetailState>(
          bloc: detailBloc
            ..add(const LoadImageSettingsDetail(ImageConnectorType.cloudinary)),
          builder: (BuildContext context, RepositorySettingsDetailState state) {
            if (state is RepositorySettingsDetailLoaded) {
              return CloudinaryTextDialog(
                instance: state.instance as CloudinaryInstance?,
              );
            }

            return const Dialog(child: CircularProgressIndicator());
          },
        );
      },
    ).then((CloudinaryInstance? instance) {
      if (instance != null) {
        BlocProvider.of<RepositorySettingsManagerBloc>(context).add(
          UpdateImageConnectionSettings(
            ImageConnectorType.cloudinary,
            instance,
          ),
        );
      }
    });
  }

  RadioListTile<ImageConnectorType> _localImageRadio(
    BuildContext context,
    ImageConnectorType? radioGroup,
  ) {
    return RadioListTile<ImageConnectorType>(
      title: Text(GameCollectionLocalisations.of(context).localString),
      groupValue: radioGroup,
      value: ImageConnectorType.local,
      onChanged: null,
    );
  }
}

class PostgresTextDialog extends TextDialog {
  const PostgresTextDialog({Key? key, required this.instance})
      : super(key: key);

  final PostgresInstance? instance;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final PostgresCredentials defaultInstance = PostgresCredentials();

    return AlertDialog(
      title: const Text(GameCollectionLocalisations.postgresString),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  textFormField(
                    labelText:
                        GameCollectionLocalisations.of(context).hostString,
                    initialValue: instance?.host,
                    onSaved: (String? value) {
                      defaultInstance.host = value ?? defaultInstance.host;
                    },
                  ),
                  numberFormField(
                    labelText:
                        GameCollectionLocalisations.of(context).portString,
                    initialValue: instance?.port,
                    onSaved: (String? value) {
                      defaultInstance.port =
                          int.parse(value ?? defaultInstance.port.toString());
                    },
                  ),
                  textFormField(
                    labelText:
                        GameCollectionLocalisations.of(context).databaseString,
                    initialValue: instance?.database,
                    onSaved: (String? value) {
                      defaultInstance.database =
                          value ?? defaultInstance.database;
                    },
                  ),
                  textFormField(
                    labelText:
                        GameCollectionLocalisations.of(context).userString,
                    initialValue: instance?.user,
                    onSaved: (String? value) {
                      defaultInstance.user = value ?? defaultInstance.user;
                    },
                  ),
                  textFormField(
                    labelText:
                        GameCollectionLocalisations.of(context).passwordString,
                    initialValue: instance?.password,
                    obscureText: true,
                    onSaved: (String? value) {
                      defaultInstance.password =
                          value ?? defaultInstance.password;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () {
            Navigator.maybePop<PostgresInstance>(context);
          },
        ),
        TextButton(
          child: Text(MaterialLocalizations.of(context).saveButtonLabel),
          onPressed: () {
            if (formKey.currentState != null &&
                formKey.currentState!.validate()) {
              formKey.currentState!.save();
              Navigator.maybePop<PostgresInstance>(context, defaultInstance);
            }
          },
        ),
      ],
    );
  }
}

class CloudinaryTextDialog extends TextDialog {
  const CloudinaryTextDialog({Key? key, required this.instance})
      : super(key: key);

  final CloudinaryInstance? instance;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final CloudinaryCredentials defaultInstance = CloudinaryCredentials();

    return AlertDialog(
      title: const Text(GameCollectionLocalisations.cloudinaryString),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  textFormField(
                    labelText:
                        GameCollectionLocalisations.of(context).cloudNameString,
                    initialValue: instance?.cloudName,
                    onSaved: (String? value) {
                      defaultInstance.cloudName =
                          value ?? defaultInstance.cloudName;
                    },
                  ),
                  numberFormField(
                    labelText:
                        GameCollectionLocalisations.of(context).apiKeyString,
                    initialValue: instance?.apiKey,
                    onSaved: (String? value) {
                      defaultInstance.apiKey =
                          int.parse(value ?? defaultInstance.apiKey.toString());
                    },
                  ),
                  textFormField(
                    labelText:
                        GameCollectionLocalisations.of(context).apiSecretString,
                    initialValue: instance?.apiSecret,
                    obscureText: true,
                    onSaved: (String? value) {
                      defaultInstance.apiSecret =
                          value ?? defaultInstance.apiSecret;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () {
            Navigator.maybePop<CloudinaryCredentials>(context);
          },
        ),
        TextButton(
          child: Text(MaterialLocalizations.of(context).saveButtonLabel),
          onPressed: () {
            if (formKey.currentState != null &&
                formKey.currentState!.validate()) {
              formKey.currentState!.save();
              Navigator.maybePop<CloudinaryCredentials>(
                context,
                defaultInstance,
              );
            }
          },
        ),
      ],
    );
  }
}

abstract class TextDialog extends StatelessWidget {
  const TextDialog({
    Key? key,
  }) : super(key: key);

  Widget textFormField({
    required String labelText,
    required String? initialValue,
    bool obscureText = false,
    required void Function(String?) onSaved,
  }) {
    return _ShowHideTextField(
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
    return _ShowHideTextField(
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

class _ShowHideTextField extends StatefulWidget {
  const _ShowHideTextField({
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
  State<_ShowHideTextField> createState() => _ShowHideTextFieldState();
}

class _ShowHideTextFieldState extends State<_ShowHideTextField> {
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
