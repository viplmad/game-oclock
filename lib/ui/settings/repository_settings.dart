import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:backend/connector/connector.dart' show CloudinaryCredentials, CloudinaryConnector, CloudinaryInstance, PostgresConnector, PostgresCredentials, PostgresInstance, ProviderInstance;

import 'package:backend/model/repository_type.dart';
import 'package:backend/model/repository_tab.dart';

import 'package:backend/bloc/repository_settings/repository_settings.dart';
import 'package:backend/bloc/repository_settings_manager/repository_settings_manager.dart';

import 'package:game_collection/localisations/localisations.dart';
import 'package:game_collection/ui/common/tabs_delegate.dart';

import '../common/show_snackbar.dart';
import '../route_constants.dart';


class RepositorySettings extends StatelessWidget {
  const RepositorySettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object?>>>[
        BlocProvider<RepositorySettingsBloc>(
          create: (BuildContext context) {
            return RepositorySettingsBloc()..add(LoadRepositorySettings());
          },
        ),

        BlocProvider<RepositorySettingsManagerBloc>(
          create: (BuildContext context) {
            return RepositorySettingsManagerBloc();
          },
        ),
      ],

      child: _RepositorySettingsBody(),
    );

  }
}

// ignore: must_be_immutable
class _RepositorySettingsBody extends StatelessWidget {
  _RepositorySettingsBody({
    Key? key,
  }) : super(key: key);

  final GlobalKey<FormState> _itemFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _imageFormKey = GlobalKey<FormState>();

  final PostgresCredentials _postgresInstance = PostgresCredentials();
  final CloudinaryCredentials _cloudinaryInstance = CloudinaryCredentials();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(GameCollectionLocalisations.of(context).repositorySettingsString),
      ),
      body: _buildBody(),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildFAB(BuildContext context) {

    return BlocBuilder<RepositorySettingsBloc, RepositorySettingsState>(
      builder: (BuildContext context, RepositorySettingsState state) {
        ItemConnectorType itemType = ItemConnectorType.Postgres;
        ImageConnectorType imageType = ImageConnectorType.Cloudinary;

        if(state is RepositorySettingsLoading) {

          return FloatingActionButton.extended(
            tooltip: GameCollectionLocalisations.of(context).saveString,
            label: Text(GameCollectionLocalisations.of(context).saveString),
            icon: const Icon(Icons.save),
            onPressed: null,
          );

        }
        if(state is RepositorySettingsLoaded) {
          itemType = state.itemType;
          imageType = state.imageType;
        }

        return FloatingActionButton.extended(
          tooltip: GameCollectionLocalisations.of(context).saveString,
          label: Text(GameCollectionLocalisations.of(context).saveString),
          icon: const Icon(Icons.save),
          onPressed: () {
            if (_itemFormKey.currentState != null && _itemFormKey.currentState!.validate() && _imageFormKey.currentState != null && _imageFormKey.currentState!.validate()) {
              _itemFormKey.currentState!.save();
              _imageFormKey.currentState!.save();

              BlocProvider.of<RepositorySettingsManagerBloc>(context).add(
                UpdateConnectionSettings(
                  itemType,
                  _postgresInstance,
                  imageType,
                  _cloudinaryInstance,
                ),
              );
            }
          },
        );
      }
    );
  }

  Widget _buildBody() {

    return SingleChildScrollView(
      child: Container(
        child: BlocListener<RepositorySettingsManagerBloc, RepositorySettingsManagerState>(
          listener: (BuildContext context, RepositorySettingsManagerState state) {
            if(state is RepositorySettingsUpdated) {
              Navigator.pushReplacementNamed(
                context,
                connectRoute,
              );
            }
            if(state is RepositorySettingsNotUpdated) {
              final String message = GameCollectionLocalisations.of(context).unableToUpdateConnectionString;
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
              ProviderInstance? itemInstance;
              ProviderInstance? imageInstance;
              ItemConnectorType itemRadioGroup = ItemConnectorType.Postgres;
              ImageConnectorType imageRadioGroup = ImageConnectorType.Cloudinary;

              if(state is RepositorySettingsLoading) {

                return const LinearProgressIndicator();

              }
              if(state is RepositorySettingsLoaded) {
                itemRadioGroup = state.itemType;
                imageRadioGroup = state.imageType;
                itemInstance = state.itemInstance;
                imageInstance = state.imageInstance;
              }

              final List<String> tabTitles = <String>[
                GameCollectionLocalisations.of(context).itemConnectionString,
                GameCollectionLocalisations.of(context).imageConnectionString,
              ];

              return DefaultTabController(
                length: tabTitles.length,
                initialIndex: state.repositoryTab.index,
                child: Builder(
                  builder: (BuildContext context) {
                    DefaultTabController.of(context)!.addListener( () {
                      final RepositoryTab newTab = RepositoryTab.values.elementAt(DefaultTabController.of(context)!.index);

                      BlocProvider.of<RepositorySettingsBloc>(context).add(UpdateRepositoryTab(newTab));
                    });

                    return NestedScrollView(
                      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverPersistentHeader(
                            pinned: true,
                            floating: true,
                            delegate: TabsDelegate(
                              tabBar: TabBar(
                                tabs: tabTitles.map<Tab>( (String title) {
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
                          _itemExpansionPanelList(context, itemRadioGroup, itemInstance),
                          _imageExpansionPanelList(context, imageRadioGroup, imageInstance),
                        ],
                      ),
                    );
                  },
                ),
              );

            },
          ),
        ),
      ),
    );

  }

  ExpansionPanelList _itemExpansionPanelList(BuildContext context, ItemConnectorType radioGroup, ProviderInstance? itemConnector) {
    return ExpansionPanelList(
      expansionCallback: (int panelIndex, bool isExpanded) {

        if(panelIndex == 0) {
          if(!isExpanded) {

            BlocProvider.of<RepositorySettingsBloc>(context).add(
              const UpdateItemTypeSettingsRadio(ItemConnectorType.Postgres),
            );

          }
        } else if(panelIndex == 1) {
          if(!isExpanded) {

            BlocProvider.of<RepositorySettingsBloc>(context).add(
              const UpdateItemTypeSettingsRadio(ItemConnectorType.Local),
            );

          }
        }

      },
      children: <ExpansionPanel>[
        _postgresExpansionPanel(context, radioGroup, itemConnector as PostgresConnector?),
        //_localExpansionPanel(context, radioGroup),
      ],
    );
  }

  ExpansionPanelList _imageExpansionPanelList(BuildContext context, ImageConnectorType radioGroup, ProviderInstance? imageConnector) {
    return ExpansionPanelList(
      expansionCallback: (int panelIndex, bool isExpanded) {

        if(panelIndex == 0) {
          if(!isExpanded) {

            BlocProvider.of<RepositorySettingsBloc>(context).add(
              const UpdateImageTypeSettingsRadio(ImageConnectorType.Cloudinary),
            );

          }
        } else if(panelIndex == 1) {
          if(!isExpanded) {

            BlocProvider.of<RepositorySettingsBloc>(context).add(
              const UpdateImageTypeSettingsRadio(ImageConnectorType.Local),
            );

          }
        }

      },
      children: <ExpansionPanel>[
        _cloudinaryExpansionPanel(context, radioGroup, imageConnector as CloudinaryConnector?),
        //_localExpansionPanel(context, radioGroup),
      ],
    );
  }

  ExpansionPanel _postgresExpansionPanel(BuildContext context, ItemConnectorType radioGroup, PostgresConnector? itemConnector) {
    final PostgresInstance? postgresInstance = itemConnector?.instance;

    return _itemExpansionPanel(
      context,
      radioGroup: radioGroup,
      radioValue: ItemConnectorType.Postgres,
      title: 'Postgres',
      textForms: <Widget>[
        _textFormField(
          labelText: GameCollectionLocalisations.of(context).hostString,
          initialValue: postgresInstance?.host,
          onSaved: (String? value) {
            _postgresInstance.host = value?? _postgresInstance.host;
          },
        ),
        _numberFormField(
          labelText: GameCollectionLocalisations.of(context).portString,
          initialValue: postgresInstance?.port,
          onSaved: (String? value) {
            _postgresInstance.port = int.parse(value?? _postgresInstance.port.toString());
          },
        ),
        _textFormField(
          labelText: GameCollectionLocalisations.of(context).databaseString,
          initialValue: postgresInstance?.database,
          onSaved: (String? value) {
            _postgresInstance.database = value?? _postgresInstance.database;
          },
        ),
        _textFormField(
          labelText: GameCollectionLocalisations.of(context).userString,
          initialValue: postgresInstance?.user,
          onSaved: (String? value) {
            _postgresInstance.user = value?? _postgresInstance.user;
          },
        ),
        _textFormField(
          labelText: GameCollectionLocalisations.of(context).passwordString,
          initialValue: postgresInstance?.password,
          obscureText: true,
          onSaved: (String? value) {
            _postgresInstance.password = value?? _postgresInstance.password;
          },
        ),
      ],
    );
  }

  ExpansionPanel _cloudinaryExpansionPanel(BuildContext context, ImageConnectorType radioGroup, CloudinaryConnector? imageConnector) {
    final CloudinaryInstance? cloudinaryInstance = imageConnector?.instance;

    return _imageExpansionPanel(
      context,
      radioGroup: radioGroup,
      radioValue: ImageConnectorType.Cloudinary,
      title: 'Cloudinary',
      textForms: <Widget>[
        _textFormField(
          labelText: GameCollectionLocalisations.of(context).cloudNameString,
          initialValue: cloudinaryInstance?.cloudName,
          onSaved: (String? value) {
            _cloudinaryInstance.cloudName = value?? _cloudinaryInstance.cloudName;
          },
        ),
        _numberFormField(
          labelText: GameCollectionLocalisations.of(context).apiKeyString,
          initialValue: cloudinaryInstance?.apiKey,
          onSaved: (String? value) {
            _cloudinaryInstance.apiKey = int.parse(value?? _cloudinaryInstance.apiKey.toString());
          },
        ),
        _textFormField(
          labelText: GameCollectionLocalisations.of(context).apiSecretString,
          initialValue: cloudinaryInstance?.apiSecret,
          obscureText: true,
          onSaved: (String? value) {
            _cloudinaryInstance.apiSecret = value?? _cloudinaryInstance.apiSecret;
          },
        ),
      ],
    );
  }

  Widget _textFormField({required String labelText, required String? initialValue, bool obscureText = false, required void Function(String?) onSaved}) {

    return _ShowHideTextField(
      labelText: labelText,
      initialValue: initialValue?? '',
      allowObscureText: obscureText,
      onSaved: onSaved,
      keyboardType: TextInputType.text,
    );

  }

  Widget _numberFormField({required String labelText, required int? initialValue, bool obscureText = false, required void Function(String?) onSaved}) {

    return _ShowHideTextField(
      labelText: labelText,
      initialValue: initialValue?.toString()?? '',
      allowObscureText: obscureText,
      onSaved: onSaved,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
    );

  }

  ExpansionPanel _itemExpansionPanel(BuildContext context, {required ItemConnectorType radioGroup, required ItemConnectorType radioValue, required String title, required List<Widget> textForms}) {

    return ExpansionPanel(
      isExpanded: radioGroup == radioValue,
      canTapOnHeader: true,
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          leading: IgnorePointer(
            child: Radio<ItemConnectorType>(
                groupValue: radioGroup,
                value: radioValue,
                onChanged: (_) {}
            ),
          ),
          title: Text(title),
        );
      },
      body: Form(
        key: _itemFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: textForms,
        ),
      ),
    );

  }

  ExpansionPanel _imageExpansionPanel(BuildContext context, {required ImageConnectorType radioGroup, required ImageConnectorType radioValue, required String title, required List<Widget> textForms}) {

    return ExpansionPanel(
      isExpanded: radioGroup == radioValue,
      canTapOnHeader: true,
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          leading: IgnorePointer(
            child: Radio<ImageConnectorType>(
                groupValue: radioGroup,
                value: radioValue,
                onChanged: (_) {}
            ),
          ),
          title: Text(title),
        );
      },
      body: Form(
        key: _imageFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: textForms,
        ),
      ),
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
      padding: const EdgeInsets.only(left: 8.0, top: 4.0, right: 8.0, bottom: 4.0),
      child: TextFormField(
        initialValue: widget.initialValue,
        obscureText: widget.allowObscureText? obscureText : false,
        maxLines: 1,
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: const OutlineInputBorder(),
          suffixIcon: widget.allowObscureText? IconButton(
            tooltip: obscureText?
              GameCollectionLocalisations.of(context).showString
              :
              GameCollectionLocalisations.of(context).hideString,
            icon: obscureText? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
          ) : null,
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