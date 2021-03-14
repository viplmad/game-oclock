import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/connector/image/cloudinary/cloudinary_connector.dart';
import 'package:game_collection/connector/item/sql/postgres/postgres_connector.dart';

import 'package:game_collection/model/repository_type.dart';

import 'package:game_collection/bloc/repository_settings/repository_settings.dart';
import 'package:game_collection/bloc/repository_settings_manager/repository_settings_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/show_snackbar.dart';
import '../route_constants.dart';


class RepositorySettings extends StatelessWidget {
  const RepositorySettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
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

      child: Scaffold(
        appBar: AppBar(
          title: Text(GameCollectionLocalisations.of(context).repositorySettingsString),
        ),
        body: _RepositorySettingsBody(),
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
              String message = GameCollectionLocalisations.of(context).unableToUpdateConnectionString;
              showSnackBar(
                scaffoldState: Scaffold.of(context),
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
              PostgresInstance? postgresInstance;
              CloudinaryInstance? cloudinaryInstance;
              RepositoryType radioGroup = RepositoryType.Remote;

              if(state is RepositorySettingsLoading) {

                return LinearProgressIndicator();

              }
              if(state is EmptyRepositorySettings) {
                radioGroup = RepositoryType.Remote;
              }
              if(state is RemoteRepositorySettingsLoaded) {
                radioGroup = state.radio;
                postgresInstance = state.postgresInstance;
                cloudinaryInstance = state.cloudinaryInstance;
              }
              /*if(state is Local) {}*/

              return ExpansionPanelList(
                expansionCallback: (int panelIndex, bool isExpanded) {

                  if(panelIndex == 0) {
                    if(!isExpanded) {

                      BlocProvider.of<RepositorySettingsBloc>(context).add(
                        UpdateRepositorySettingsRadio(RepositoryType.Remote),
                      );

                    }
                  } else if(panelIndex == 1) {
                    if(!isExpanded) {

                      BlocProvider.of<RepositorySettingsBloc>(context).add(
                        UpdateRepositorySettingsRadio(RepositoryType.Local),
                      );

                    }
                  }

                },
                children: [
                  _remoteExpansionPanel(context, radioGroup, postgresInstance, cloudinaryInstance),
                  //_localRepositoryPanel(context, radioGroup),
                ],
              );

            },
          ),
        ),
      ),
    );

  }

  ExpansionPanel _remoteExpansionPanel(BuildContext context, RepositoryType radioGroup, [PostgresInstance? postgresInstance, CloudinaryInstance? cloudinaryInstance]) {

    String _host = '';
    int _port = -1;
    String _db = '';
    String _user = '';
    String _pass = '';

    String _cloud = '';
    int _apiKey = -1;
    String _apiSecret = '';

    return _repositoryExpansionPanel(
      context,
      title: GameCollectionLocalisations.of(context).remoteRepositoryString,
      radioGroup: radioGroup,
      radioValue: RepositoryType.Remote,
      textForms: [
        _headerText(context, 'Postgres'),
        _textFormField(
          labelText: GameCollectionLocalisations.of(context).hostString,
          initialValue: (postgresInstance != null)? postgresInstance.host : _host,
          onSaved: (String? value) {
            _host = value?? _host;
          },
        ),
        _numberFormField(
          labelText: GameCollectionLocalisations.of(context).portString,
          initialValue: (postgresInstance != null)? postgresInstance.port : _port,
          onSaved: (String? value) {
            _port = int.parse(value?? _port.toString());
          },
        ),
        _textFormField(
          labelText: GameCollectionLocalisations.of(context).databaseString,
          initialValue: (postgresInstance != null)? postgresInstance.database : _db,
          onSaved: (String? value) {
            _db = value?? _db;
          },
        ),
        _textFormField(
          labelText: GameCollectionLocalisations.of(context).userString,
          initialValue: (postgresInstance != null)? postgresInstance.user : _user,
          onSaved: (String? value) {
            _user = value?? _user;
          },
        ),
        _textFormField(
          labelText: GameCollectionLocalisations.of(context).passwordString,
          initialValue: (postgresInstance != null)? postgresInstance.password : _pass,
          obscureText: true,
          onSaved: (String? value) {
            _pass = value?? _pass;
          },
        ),
        _headerText(context, 'Cloudinary'),
        _textFormField(
          labelText: GameCollectionLocalisations.of(context).cloudNameString,
          initialValue: (cloudinaryInstance != null)? cloudinaryInstance.cloudName : _cloud,
          onSaved: (String? value) {
            _cloud = value?? _cloud;
          },
        ),
        _numberFormField(
          labelText: GameCollectionLocalisations.of(context).apiKeyString,
          initialValue: (cloudinaryInstance != null)? cloudinaryInstance.apiKey : _apiKey,
          onSaved: (String? value) {
            _apiKey = int.parse(value?? _apiKey.toString());
          },
        ),
        _textFormField(
          labelText: GameCollectionLocalisations.of(context).apiSecretString,
          initialValue: (cloudinaryInstance != null)? cloudinaryInstance.apiSecret : _apiSecret,
          obscureText: true,
          onSaved: (String? value) {
            _apiSecret = value?? _apiSecret;
          },
        ),
      ],
      onUpdate: () {
        BlocProvider.of<RepositorySettingsManagerBloc>(context).add(
          UpdateRemoteConnectionSettings(
            PostgresInstance(
              _host,
              _port,
              _db,
              _user,
              _pass,
            ),
            CloudinaryInstance(
              _cloud,
              _apiKey,
              _apiSecret,
            ),
          ),
        );
      }
    );

  }

  /*ExpansionPanel _localRepositoryPanel(BuildContext context, RepositoryType radioGroup) {

    return _repositoryExpansionPanel(
      context,
      title: GameCollectionLocalisations.of(context).localRepositoryString,
      radioGroup: radioGroup,
      radioValue: RepositoryType.Local,
      textForms: [],
    );

  }*/

  Widget _headerText(BuildContext context, String text) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: Theme.of(context).textTheme.headline6),
    );

  }

  Widget _textFormField({required String labelText, required String initialValue, bool obscureText = false, required void Function(String?) onSaved}) {

    return _ShowHideTextField(
      labelText: labelText,
      initialValue: initialValue,
      allowObscureText: obscureText,
      onSaved: onSaved,
      keyboardType: TextInputType.text,
    );

  }

  Widget _numberFormField({required String labelText, required int initialValue, bool obscureText = false, required void Function(String?) onSaved}) {

    return _ShowHideTextField(
      labelText: labelText,
      initialValue: initialValue.toString(),
      allowObscureText: obscureText,
      onSaved: onSaved,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );

  }

  ExpansionPanel _repositoryExpansionPanel(BuildContext context, {required RepositoryType radioGroup, required RepositoryType radioValue, required String title, required List<Widget> textForms, required void Function() onUpdate}) {

    final _formKey = GlobalKey<FormState>();

    return ExpansionPanel(
      isExpanded: radioGroup == radioValue,
      canTapOnHeader: true,
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          leading: IgnorePointer(
            child: Radio<RepositoryType>(
                groupValue: radioGroup,
                value: radioValue,
                onChanged: (_) {}
            ),
          ),
          title: Text(title),
        );
      },
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: textForms..add(
            SizedBox(
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    GameCollectionLocalisations.of(context).saveString,
                    style: TextStyle(color: Colors.white),
                  ),
                  elevation: 1.0,
                  highlightElevation: 2.0,
                  onPressed: () {
                    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      onUpdate();
                    }
                  },
                ),
              ),
            ),
          ),
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
          border: OutlineInputBorder(),
          suffixIcon: widget.allowObscureText? IconButton(
            tooltip: obscureText?
              GameCollectionLocalisations.of(context).showString
              :
              GameCollectionLocalisations.of(context).hideString,
            icon: obscureText? Icon(Icons.visibility_off) : Icon(Icons.visibility),
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
          ) : null,
        ),
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        validator: (value) {
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