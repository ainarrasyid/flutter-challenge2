import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:challenge2/core/data/model/user.dart';
import 'package:challenge2/core/utils/media_service.dart';
import 'package:challenge2/core/utils/status.dart';
import 'package:challenge2/core/widgets/app_button.dart';
import 'package:challenge2/core/widgets/app_topbar.dart';
import 'package:challenge2/core/widgets/app_colors.dart';
import 'package:challenge2/core/widgets/app_textfield.dart';
import 'package:challenge2/di/injection.dart';
import 'package:challenge2/ui/bloc/main_bloc.dart';
import 'package:challenge2/gen/assets.gen.dart';
import 'package:challenge2/core/utils/translation.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final mediaService = getIt<MediaService>();
  User? user;
  File? newProfileImage;
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();

  changeProfileImage(File? file) {
    if (file != null) {
      setState(() {
        newProfileImage = file;
      });
    }
  }

  updateProfile() {
    if (newProfileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.text.label_error_no_picture_found)));
    } else if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.text.label_error_field_empty('Name'))));
    } else {
      BlocProvider.of<MainBloc>(context)
          .add(UpdateUser(name: nameController.text, photo: newProfileImage!));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content() {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    mediaService
                        .getImage(context, AppImageSource.camera)
                        .then((file) => changeProfileImage(file));
                  },
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundImage: newProfileImage != null
                            ? FileImage(newProfileImage!)
                            : user == null
                                ? Assets.images.icUser.image() as ImageProvider
                                : NetworkImage(user!.photo!),
                      ),
                      const Icon(
                        Icons.edit,
                        color: AppColors.textGray,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
                AppTextField(
                  title: context.text.label_name,
                  hint: context.text.label_name,
                  keyboardType: TextInputType.name,
                  controller: nameController,
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget footer() {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: AppButton(
          isLoading: isLoading,
          padding: 20,
          caption: context.text.label_save,
          onPressed: () => updateProfile(),
        ),
      );
    }

    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is LoginResultState) {
          if (state.status == Status.loading) {
            isLoading = true;
          }
          if (state.status == Status.success) {
            isLoading = false;
            user = state.data;
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message.toString())));
          }
          if (state.status == Status.error) {
            isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message.toString())));
          }
        }
      },
      builder: (context, state) {
        if (state is LoginResultState && state.status == Status.success) {
          user = state.data;
          nameController.text = (user?.name != null ? user?.name! : '')!;
        }
        return Container(
          color: Colors.white,
          child: SafeArea(
            child: Scaffold(
              appBar: AppTopBar(
                onPressed: () => context.pop(),
                title: context.text.menu_edit_profile,
                height: 100,
              ),
              resizeToAvoidBottomInset: false,
              body: Column(
                children: [
                  content(),
                  footer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
