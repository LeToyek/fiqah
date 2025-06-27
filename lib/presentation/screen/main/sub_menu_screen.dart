import 'package:fiqah/data/menu_category_dto.dart';
import 'package:fiqah/presentation/screen/main/content_screen.dart';
import 'package:flutter/material.dart';

class SubMenuScreen extends StatelessWidget {
  final MenuCategory category;

  const SubMenuScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [Colors.grey[900]!, Colors.grey[800]!]
                : [Colors.grey[50]!, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildSubMenuList(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: category.gradient,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
              Icon(
                category.icon,
                size: 32,
                color: Colors.white,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  category.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Pilih materi yang ingin dipelajari',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubMenuList(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(24),
      itemCount: category.subMenus.length,
      itemBuilder: (context, index) {
        return _buildSubMenuItem(context, category.subMenus[index], index);
      },
    );
  }

  Widget _buildSubMenuItem(BuildContext context, String title, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContentScreen(
                  title: title,
                  category: category.title,
                ),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: category.gradient,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.grey[800],
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
