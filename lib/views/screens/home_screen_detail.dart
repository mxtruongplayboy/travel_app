import 'package:flutter/material.dart';
import 'package:travel_app/models/category_model.dart';
import 'package:travel_app/models/post_model.dart';
import 'package:travel_app/models/user_model.dart';
import 'package:travel_app/services/category_service.dart';
import 'package:travel_app/services/post_service.dart';
import 'package:travel_app/services/user_service.dart';
import 'package:travel_app/views/screens/welcome_screen.dart';

import '../widgets/category_widget.dart';
import '../widgets/post_vertical_widget.dart';

class HomeScreenDetail extends StatefulWidget {
  const HomeScreenDetail({
    super.key,
  });

  @override
  State<HomeScreenDetail> createState() => _HomeScreenDetailState();
}

class _HomeScreenDetailState extends State<HomeScreenDetail> {
  final CategoryService _categoryService = CategoryService();
  final PostService _postService = PostService();
  final UserService _userService = UserService();

  late Future<List<Post>> _futurePosts = Future.value([]);
  late Future<List<Category>> _futureCategories = Future.value([]);

  List<Category> _categories = [];
  int _selectedCategoryIndex = 0;
  User? _user;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  void _fetchCategories() {
    _futureCategories = _categoryService.fetchCategories();
    _futureCategories.then((categories) {
      setState(() {
        _categories = categories;
        _fetchPosts();
        _fetchUser();
      });
    });
  }

  void _fetchPosts() {
    if (_categories.isNotEmpty) {
      setState(() {
        _futurePosts = _postService.fetchPosts(
            longitude: 50, // Replace with actual longitude
            latitude: 40, // Replace with actual latitude
            categoryId: _categories[_selectedCategoryIndex].id,
            maxDistance: 20, // Use category ID
            limit: 3);
      });
    }
  }

  void _fetchUser() {
    _userService.getUserInfo().then((user) {
      setState(() {
        try {
          _user = user;
        } catch (e) {
          _showInvalidTokenDialog();
        }
      });
    });
  }

  void _showInvalidTokenDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Phiên làm việc đã hết"),
          content: const Text("Vui lòng đăng nhập lại."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WelcomeScreen(),
                  ),
                ); // Navigate to the welcome screen
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 350,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/appbar-bg.webp"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Color.fromARGB(255, 255, 87, 51),
                        width: 2,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                          'https://thumbs.dreamstime.com/b/d-icon-avatar-woman-cartoon-cute-character-young-female-traveler-hat-laggage-traveling-concept-isolated-transparent-275302866.jpg'),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700.withOpacity(0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications,
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade700.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(color: Colors.white),
                    hintText: '${_user?.name} ơi, bạn muốn đi đâu?',
                    border: InputBorder.none,
                    icon: const Icon(Icons.location_on_outlined,
                        color: Color.fromARGB(255, 255, 87, 51)),
                  ),
                  enabled: false,
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            const SizedBox(
              height: 250,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF222222),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Danh mục',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FutureBuilder<List<Category>>(
                          future: _futureCategories,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                if (snapshot.error.toString() ==
                                    'Exception: Token invalid') {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    _showInvalidTokenDialog();
                                  });
                                  return Container();
                                } else {
                                  return const Center(
                                    child: Text('Đã xảy ra lỗi'),
                                  );
                                }
                              }
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: snapshot.data!
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    int idx = entry.key;
                                    Category category = entry.value;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedCategoryIndex = idx;
                                        });
                                        _fetchPosts();
                                      },
                                      child: CategoryWidget(
                                        icon: category.iconName,
                                        label: category.name,
                                        isSelected:
                                            idx == _selectedCategoryIndex,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.orangeAccent),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Khám phá',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FutureBuilder<List<Post>>(
                          future: _futurePosts,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                if (snapshot.error.toString() ==
                                    'Exception: Token invalid') {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    _showInvalidTokenDialog();
                                  });
                                  return Container();
                                } else {
                                  return const Center(
                                    child: Text('Đã xảy ra lỗi'),
                                  );
                                }
                              }
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: snapshot.data!.map((post) {
                                    return PostVerticalWidget(post: post);
                                  }).toList(),
                                ),
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.orangeAccent),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
