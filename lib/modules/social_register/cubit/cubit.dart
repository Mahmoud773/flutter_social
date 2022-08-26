import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/social_user_model.dart';
import 'package:flutter_app/modules/social_register/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
  @required email ,
    @required password ,
    @required String name,
    @required String phone,
}){
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).
    then((value) {
      emit(SocialRegisterSuccessState());
       userCreate(name: name, email: email, phone: phone, uId: value.user.uid);
    }
    )
        .catchError((error){
      emit(SocialRegisterErrorState(error.toString()));

    });
  }

  void userCreate({@required String name,
    @required String email,
    @required String phone,
    @required String uId,} ){

    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      bio: 'write you bio ...',
      cover: 'https://image.freepik.com/free-photo/photo-attractive-bearded-young-man-with-cherful-expression-makes-okay-gesture-with-both-hands-likes-something-dressed-red-casual-t-shirt-poses-against-white-wall-gestures-indoor_273609-16239.jpg',
      image: 'https://image.freepik.com/free-photo/photo-attractive-bearded-young-man-with-cherful-expression-makes-okay-gesture-with-both-hands-likes-something-dressed-red-casual-t-shirt-poses-against-white-wall-gestures-indoor_273609-16239.jpg',
      isEmailVerified: false,
    );
    FirebaseFirestore.instance.collection('users').doc(uId).set(model.toMap()).then(
            (value) {
              emit(SocialCreateUserSuccessState());
            }
    )
    .catchError((error) {
      emit(SocialCreateUserErrorState(error.toString()));
    });
  }



 // SocialLoginModel loginModel;


  // void userRegister({
  //   @required String name,
  //   @required String email,
  //   @required String password,
  //   @required String phone,
  // })
  // {
  //   emit(SocialRegisterLoadingState());
  //
  //   DioHelper.postData(
  //     url: REGISTER,
  //     data:
  //     {
  //       'name': name,
  //       'email': email,
  //       'password': password,
  //       'phone': phone,
  //     },
  //   ).then((value)
  //   {
  //     print(value.data);
  //     loginModel = ShopLoginModel.fromJson(value.data);
  //     emit(ShopRegisterSuccessState(loginModel));
  //   }).catchError((error)
  //   {
  //     print(error.toString());
  //     emit(ShopRegisterErrorState(error.toString()));
  //   });
  // }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ;

    emit(SocialRegisterChangePasswordVisibilityState());
  }
}