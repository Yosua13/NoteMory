import 'package:flutter/material.dart';
import 'package:note_mory/models/note.dart';
import 'package:note_mory/presentation/create_note_page.dart';
import 'package:note_mory/presentation/detail_note_page.dart';
import 'package:note_mory/presentation/login_page.dart';
import 'package:note_mory/providers/google_sign_in_provider.dart';
import 'package:note_mory/providers/note_provider.dart';
import 'package:note_mory/providers/onboarding_provider.dart';
import 'package:note_mory/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<NoteProvider>().loadNotes());
    Provider.of<NoteProvider>(context, listen: false).loadNotes();
    Provider.of<UserProvider>(context, listen: false).loginUser('', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF440C0C),
                Color(0xFF000000),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        title: const Text(
          'NoteMory',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              size: 28,
              color: Color(0xFFFFFFFF),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Apakah Anda ingin Keluar"),
                    backgroundColor: const Color(0xFFFFB300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    actions: [
                      TextButton(
                        child: const Text(
                          "Tidak",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text(
                          "Ya",
                          style: TextStyle(
                            color: Color(0xFF440C0C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          // onboarding
                          await Provider.of<OnboardingProvider>(context,
                                  listen: false)
                              .setLoggedIn(false);

                          await Provider.of<UserProvider>(context,
                                  listen: false)
                              .logoutUser();
                          await Provider.of<GoogleSignInProvider>(context,
                                  listen: false)
                              .logoutUser(context);
                          Navigator.of(context).pop();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 24,
          right: 24,
        ),
        child: Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateNotePage(),
                ),
              );
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(
              Icons.add,
              color: Colors.black,
              size: 36,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF000000),
              Color(0xFF440C0C),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Consumer<NoteProvider>(
          builder: (context, noteProvider, child) {
            final notes = noteProvider.notes;

            if (notes.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada catatan.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3 / 4,
              ),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                Note note = notes[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailNotePage(note: note),
                      ),
                    );
                    debugPrint('DEBUG: ID: ${note.id}');
                    debugPrint('DEBUG: Title: ${note.title}');
                    debugPrint('DEBUG: Content: ${note.content}');
                    debugPrint('DEBUG: Date: ${note.date}');
                  },
                  child: Card(
                    color: const Color(0xFFFFB300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            note.content!,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            note.date!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
