import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:havadurumu_uygulamasi/models/weather_model.dart';
import 'package:havadurumu_uygulamasi/route/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> sehirlerList = [
    "Ankara",
    "Bursa",
    "İstanbul",
    "İzmir",
    "Çanakkale",
    "Aydın",
    "Trabzon",
    "Rize"
  ];
  String? secilenSehir;
  Future<WeatherModel>? weatherModel;
  late TextEditingController _searchController;
  String _aramaSonucu = "";

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(
      () {
        setState(() {
          _aramaSonucu = _searchController.text;
          //weatherModel=getWeather(_aramaSonucu);
        });
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void selectedCity(String sehir) {
    setState(() {
      secilenSehir = sehir;
      weatherModel = getWeather(sehir);
    });
  }

  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.openweathermap.org/data/2.5',
      queryParameters: {
        "appid": "xxxxxxxxxxxxxxxxxxxx",
        "lang": "tr",
        "units": "metric"
      }));

  // get isteği
  Future<WeatherModel> getWeather(String secilenSehir) async {
    try {
      final response =
          await dio.get('/weather', queryParameters: {"q": secilenSehir});

      //debugPrint(response.data.toString());
      var model = WeatherModel.fromJson(response.data);
      debugPrint(model.main?.temp.toString());

      return model;
    } on DioException catch (e) {
      var error = "Bir sorun olustu lütfen tekrar deneyin!";
      return Future.error(error);
    }
  }

  Widget _buildWeatherCard(WeatherModel weatherModel) {
    // hava durumu iconu için fotoyu çekeçeğimiz url
    var iconUrl =
        "https://openweathermap.org/img/wn/${weatherModel.weather![0].icon}@2x.png";
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.detail, arguments: weatherModel);
      },
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                weatherModel.name!,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 8,
              ),
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.surface,
                radius: 100,
                child: Image.network(iconUrl),
              ),
              Text(
                weatherModel.main!.temp!.round().toString() + "°",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                weatherModel.weather![0].description ?? "Değer bulunamadı",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Icon(Icons.water_drop),
                      Text(weatherModel.main!.humidity!.toString())
                    ],
                  ),
                  SizedBox(
                    width: 32,
                  ),
                  Column(
                    children: [
                      Icon(Icons.air),
                      Text(weatherModel.wind!.speed!.round().toString())
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _aramaYap(String aranan) {
    setState(() {
      if (_searchController.text != "") {
        weatherModel = getWeather(_searchController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hava Durumu"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (weatherModel != null)
            // burada future kısmına weatherModel yazmamızın sebebi her setState olduğunda tekrar veri çekmemek için
            //getWeather yazsaydık gereksiz get çağrısı yapacaktı
            FutureBuilder(
              future: weatherModel,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return _buildWeatherCard(snapshot.data!);
                }

                return SizedBox();
              },
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                prefixIcon: const Icon(Icons.location_city),
                suffixIcon: IconButton(
                    onPressed: () {
                      _aramaYap(_searchController.text);
                      setState(() {
                        secilenSehir = "";
                      });
                    },
                    icon: const Icon(Icons.search)),
                hintText: "Şehir arayın...",
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              onSubmitted: _aramaYap,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Popüler şehirler",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                var isSelected = secilenSehir == sehirlerList[index];
                return GestureDetector(
                  onTap: () => selectedCity(sehirlerList[index]),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      color: isSelected ? Colors.grey : null,
                      child: SizedBox(
                        height: 50,
                        child: Center(child: Text(sehirlerList[index])),
                      ),
                    ),
                  ),
                );
              },
              itemCount: sehirlerList.length,
              padding: const EdgeInsets.all(8),
            ),
          )
        ],
      ),
    );
  }
}
