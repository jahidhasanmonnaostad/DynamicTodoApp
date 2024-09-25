class TodoModel {
  int id;
  final String title;
  bool isDone;

  TodoModel( {required this.id,required this.title,this.isDone=false});
}