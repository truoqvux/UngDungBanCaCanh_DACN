import 'package:flutter/material.dart';
import 'package:ung_dung_ban_ca_canh/model/comment_model.dart';

// ignore: must_be_immutable
class CommentWidget extends StatelessWidget {
  CommentModel model;
  CommentWidget({super.key, required this.model});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
      margin: const EdgeInsets.only(bottom: 7),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 233, 233, 233),
          borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
          backgroundImage: NetworkImage(
              'https://as2.ftcdn.net/v2/jpg/03/49/49/79/1000_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.jpg'),
          radius: 20,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            model.content ?? "",
            style: const TextStyle(
                fontSize: 13, color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
        title: Text(
          model.username ?? "_username ",
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
