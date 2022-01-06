class devInfo{
   final String name;
   final String Class;
   final String Iconimage;
   final String regNo;
  devInfo(
    this.regNo,{
      required this.name,
      required this.Iconimage,
      required this.Class,
    }
  );
}
List<devInfo> developers =[
  devInfo('20352012', name: 'Archana A', Iconimage: 'assets/image/woman.png', Class: 'Mca 2nd Year'),
  devInfo('20352017', name: 'Parvathi G', Iconimage: 'assets/image/beauty.png', Class: 'Mca 2nd Year'),
  devInfo('20352020', name: 'Dheeraj J', Iconimage: 'assets/image/man.png', Class: 'Mca 2nd Year'),
  
];