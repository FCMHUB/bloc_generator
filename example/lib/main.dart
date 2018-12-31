import "package:flutter/material.dart";
import "package:flutter_bloc_example/bloc.dart";

import "package:flutter_bloc_provider/flutter_bloc_provider.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: "Flutter Demo",
			theme: ThemeData(
				primarySwatch: Colors.blue,
			),
			home: BLoCDisposer<TestBLoC>(
				bloc: TestBLoC(
					maxValue: 20
				),
				child: MyHomePage(title: "Flutter Demo Home Page")
			)
		);
	}
}

class MyHomePage extends StatelessWidget {
	final String title;

	MyHomePage({
		this.title
	});

	@override
	Widget build(BuildContext context) {
		final TestBLoC bloc = BLoCProvider.of<TestBLoC>(context);
		return Scaffold(
			appBar: AppBar(
				title: Text(title),
			),
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						Text("You have pushed the button this many times:"),
						StreamBuilder(
							stream: bloc.counter,
							builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
								if(!snapshot.hasData)
									return Container();

								return Column(
									children: <Widget>[
										Text(
											snapshot.data,
											style: Theme.of(context).textTheme.display1
										),

										Row(
											mainAxisAlignment: MainAxisAlignment.center,
											children: <Widget>[
												MaterialButton(
													child: Text("Reset Counter"),
													onPressed: () => bloc.setCounter.add(0)
												),

												MaterialButton(
													child: Text("Tutorial"),
													onPressed: bloc.triggerTutorialService
												)
											]
										)
									]
								);
							}
						),
					]
				)
			),
			floatingActionButton: FloatingActionButton(
				onPressed: () => bloc.addToCounter.add(1),
				tooltip: "Increment",
				child: Icon(Icons.add)
			)
		);
	}
}