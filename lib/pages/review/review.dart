import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_oclock/blocs/blocs.dart'
    show ActionStarted, ListLoadBloc, ReviewYearSelectBloc;
import 'package:game_oclock/components/list/grid_list.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              ReviewYearSelectBloc()
                ..add(ActionStarted(data: DateTime.now().year)),
        ),
      ],
      child: Center(),
    );
  }

  Widget main<T, LB extends ListLoadBloc<T>, SB>({
    required final String title,
    required final Widget Function(
      BuildContext context,
      T data,
      VoidCallback onPressed,
    )
    listItemBuilder,
  }) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: GridListBuilder<T, LB>(
        space: '',
        itemBuilder: (final context, final data, final index) =>
            listItemBuilder(
              context,
              data,
              () {} /*_select(
                context,
                selectBloc: context.read<SB>(),
                data: data == selectedData
                    ? null // Remove selection if pressed on the same one
                    : data,
              )*/,
            ),
      ),
    );
  }
}
