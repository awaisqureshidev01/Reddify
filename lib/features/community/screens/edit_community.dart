// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils.dart';
import '../../../models/community_model.dart';
import '../../../responsive/responsive.dart';
import '../../../theme/pallete.dart';
import '../controller/community_controller.dart';

class EditCommunity extends ConsumerStatefulWidget {
  String name;
  EditCommunity({
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditCommunityState();
}

class _EditCommunityState extends ConsumerState<EditCommunity> {
  File? bannerFile;
  File? profileFile;
  Uint8List? bannerWebFile;
  Uint8List? profileWebFile;
  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          bannerFile = File(res.files.first.path!);
        });
      }
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      if (kIsWeb) {
        setState(() {
          profileWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          profileFile = File(res.files.first.path!);
        });
      }
    }
  }

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
        bannerFile: bannerFile,
        profileFile: profileFile,
        context: context,
        community: community,
        banneWebFile: bannerWebFile,
        profileWebFile: profileWebFile);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
        data: (community) => Scaffold(
              backgroundColor: currentTheme.backgroundColor,
              appBar: AppBar(
                title: Text('Edit Community'),
                actions: [
                  TextButton(
                    onPressed: () => save(community),
                    child: Text('Save'),
                  ),
                ],
              ),
              body: isLoading
                  ? const Loader()
                  : Responsive(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 200,
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: selectBannerImage,
                                    child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(10),
                                      dashPattern: const [10, 4],
                                      strokeCap: StrokeCap.round,
                                      color: currentTheme
                                          .textTheme.bodyText2!.color!,
                                      child: Container(
                                        width: double.infinity,
                                        height: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: bannerWebFile != null
                                            ? Image.memory(bannerWebFile!)
                                            : bannerFile != null
                                                ? Image.file(bannerFile!)
                                                : community.banner.isEmpty ||
                                                        community.banner ==
                                                            Constants
                                                                .bannerDefault
                                                    ? const Center(
                                                        child: Icon(
                                                          Icons
                                                              .camera_alt_outlined,
                                                          size: 40,
                                                        ),
                                                      )
                                                    : Image.network(
                                                        community.banner),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    child: GestureDetector(
                                      onTap: selectProfileImage,
                                      child: profileWebFile != null
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  MemoryImage(profileWebFile!),
                                              radius: 32,
                                            )
                                          : profileFile != null
                                              ? CircleAvatar(
                                                  backgroundImage:
                                                      FileImage(profileFile!),
                                                )
                                              : CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      community.avatar),
                                                ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ),
        error: ((error, stackTrace) => ErrorText(error: error.toString())),
        loading: () => const Loader());
  }
}
