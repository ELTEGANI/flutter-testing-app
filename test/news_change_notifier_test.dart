import 'package:flutter_testing_tutorial/article.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/news_service.dart';
import 'package:mocktail/mocktail.dart';

class MockNewsService extends Mock implements NewsService{}

void main(){
  late NewsChangeNotifier sut;
  late MockNewsService mockNewsService;

  setUp((){
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });


  test("initial values are correct",
        (){
      expect(sut.articles,[]);
      expect(sut.isLoading,false);
    },
  );

  group('getArticles', (){
    final articalesFromService = [
      Article(title: 'Test 1', content: 'Test 1 Content'),
      Article(title: 'Test 2', content: 'Test 2 Content'),
      Article(title: 'Test 3', content: 'Test 3 Content')
    ];

    void arrangeNewsServiceReturn3Articles(){
      when(()=>mockNewsService.getArticles()).thenAnswer((_) async => [
       Article(title: 'Test 1', content: 'Test 1 Content'),
       Article(title: 'Test 2', content: 'Test 2 Content'),
       Article(title: 'Test 3', content: 'Test 3 Content')
      ]);
    }
     test("get articles using the newsService", () async {
       arrangeNewsServiceReturn3Articles();
       await sut.getArticles();
       verify(()=>mockNewsService.getArticles()).called(1);
      });

     test("""indicates loading of data, sets articles to the ones from the service
     ,indicates that data is not being loaded anymore""",() async{
     arrangeNewsServiceReturn3Articles();
     final future = sut.getArticles();
     expect(sut.isLoading,true);
     await future;
     expect(sut.articles,articalesFromService);
     expect(sut.isLoading,false);
     });


    });


}





