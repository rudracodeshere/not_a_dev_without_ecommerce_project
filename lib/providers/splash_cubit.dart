import 'package:e_commerce_project/providers/splash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState>{
  SplashCubit() : super(DisplaySplash());
  void appStarted() async{
    await Future.delayed(const Duration(seconds: 2));
    emit(Unauthenticated());
  }
}
