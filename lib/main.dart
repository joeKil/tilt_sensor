import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SensorApp(),
    );
  }
}

class SensorApp extends StatefulWidget {
  const SensorApp({Key? key}) : super(key: key);

  @override
  State<SensorApp> createState() => _SensorAppState();
}

class _SensorAppState extends State<SensorApp> {
  @override
  Widget build(BuildContext context) {
    // 가로모드
    SystemChrome.setPreferredOrientations([
      // 허용되는 방향을 여기 로직에 넣어주기만 하면된다.
      DeviceOrientation.landscapeLeft
    ]);

    // 미디어쿼리 사용하면 원하는 위치로 옮길 수 있음.
    final centerX = MediaQuery.of(context).size.width / 2 - 50;
    final centerY = MediaQuery.of(context).size.height / 2 - 50;

    return Scaffold(
      // 컬럼이나 로우같은 경우는 겹칠 수 없지만 스택을 사용하면 칠드런끼리 겹침
      body: Stack(
        children: [
          // 원하는 위치로 옮길 수 있다.
          StreamBuilder<AccelerometerEvent>(
            // 이렇게 써주면 알아서 가속도 이벤트가 들어오게됨.
            stream: accelerometerEvents,
            builder: (context, snapshot) {
              if(!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              // 위에 돌아갔다가 밑을 타서 데이터 줌

              final event = snapshot.data!;
              List<double> accelerometerValues = [event.x, event.y, event.z];
              print(accelerometerValues);

              return Positioned(
                // 화면에 보이는 수평계 움직이게 만들기
                left: centerX + event.y * 20,
                top: centerY + event.x * 20,
                // 컨테이너는 기본적으로 화면에 꽉참
                child: Container(
                  decoration: const BoxDecoration(
                    // 컬러는 중복값이 있으면 에러뜸. 바깥쪽 말고 여기다가 넣어줘야함.
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  width: 100,
                  height: 100,
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}
