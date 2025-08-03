import 'package:game_oclock/models/models.dart' show ListSearch;

class UserGameCreateForm extends StatelessWidget {
  const UserGameCreateForm({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => UserGameFormBloc(
                formGroup: UserGameFormData(
                  title: TextEditingController(),
                  edition: TextEditingController(),
                  status: TextEditingController(),
                  rating: TextEditingController(),
                  notes: TextEditingController(),
                ),
              ),
        ),
        BlocProvider(create: (_) => UserGameCreateBloc()),
      ],
      child: const CreateEditFormBuilder<
        ListSearch,
        UserGameFormData,
        UserGameFormBloc,
        UserGameGetBloc,
        UserGameCreateBloc,
        UserGameUpdateBloc
      >(title: 'Creating', create: true, fieldsBuilder: _fieldsBuilder),
    );
  }
}
