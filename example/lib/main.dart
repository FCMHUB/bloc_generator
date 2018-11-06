import "package:flutter/material.dart";
import "package:flutter_bloc_example/bloc.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: "Flutter Demo",
			theme: ThemeData(
				primarySwatch: Colors.blue,
			),
			home: TestDisposer(
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
		return Scaffold(
			appBar: AppBar(
				title: Text(title),
			),
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						Text(
							"You have pushed the button this many times:"
						),
						StreamBuilder(
							stream: TestProvider.of(context).counter,
							builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
								if(!snapshot.hasData) { return Container(); }
								return Column(
									children: <Widget>[
										Text(
											snapshot.data,
											style: Theme.of(context).textTheme.display1
										),
										MaterialButton(
											child: Text("Reset Counter"),
											onPressed:
												TestProvider.of(context).currentCounter != "0" ?
												() => TestProvider.of(context).setCounter.add(0) :
												null
										)
									]
								);
							}
						),
					]
				)
			),
			floatingActionButton: FloatingActionButton(
				onPressed: () => TestProvider.of(context).addToCounter.add(1),
				tooltip: "Increment",
				child: Icon(Icons.add)
			)
		);
	}
}