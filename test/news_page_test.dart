import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/article.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_page.dart';
import 'package:flutter_testing_tutorial/news_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';


class MockNewsService extends Mock implements NewsService{}


void main(){
  late MockNewsService mockNewsService;

  setUp((){
    mockNewsService = MockNewsService();
  });

  final articalesFromService = [
    Article(title: 'Test 1', content: 'Test 1 Content'),
    Article(title: 'Test 2', content: 'Test 2 Content'),
    Article(title: 'Test 3', content: 'Test 3 Content')
  ];

  void arrangeNewsServiceReturn3Articles(){
    when(()=>mockNewsService.getArticles()).thenAnswer((_) async =>articalesFromService);
  }

  void arrangeNewsServiceReturn3ArticlesAfter2SecoundsWait(){
    when(()=>mockNewsService.getArticles()).thenAnswer(
            (_) async{
              await Future.delayed(Duration(seconds:2));
              return articalesFromService;
            }
    );
  }

  Widget createWidgetUnderTest(){
    return MaterialApp(
      title: 'News App',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(mockNewsService),
        child: NewsPage(),
      ),
    );
  }

  testWidgets("title is displayed", (WidgetTester tester) async{
    arrangeNewsServiceReturn3Articles();
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text("News"),findsOneWidget);
  });

  testWidgets("loading indicator is displayed while waiting for articles", (WidgetTester tester) async{
    arrangeNewsServiceReturn3ArticlesAfter2SecoundsWait();
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(microseconds:500));
    expect(find.byType(CircularProgressIndicator),findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets("articles are displayed", (WidgetTester tester) async{
    arrangeNewsServiceReturn3Articles();
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();
    for(final artical in articalesFromService){
      expect(find.text(artical.title),findsOneWidget);
      expect(find.text(artical.content),findsOneWidget);
    }
  });

}