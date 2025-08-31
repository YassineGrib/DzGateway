import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/menu_item_model.dart';

class MenuService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get all menu items for a specific restaurant
  Future<List<MenuItem>> getMenuItemsByRestaurant(String restaurantId) async {
    try {
      final response = await _supabase
          .from('menu_items')
          .select('*')
          .eq('restaurant_id', restaurantId)
          .eq('is_available', true)
          .order('category', ascending: true)
          .order('name', ascending: true);

      return (response as List)
          .map((item) => MenuItem.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('فشل في تحميل عناصر القائمة: $e');
    }
  }

  // Get menu items by category for a specific restaurant
  Future<List<MenuItem>> getMenuItemsByCategory(
      String restaurantId, String category) async {
    try {
      final response = await _supabase
          .from('menu_items')
          .select('*')
          .eq('restaurant_id', restaurantId)
          .eq('category', category)
          .eq('is_available', true)
          .order('name', ascending: true);

      return (response as List)
          .map((item) => MenuItem.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('فشل في تحميل عناصر القائمة للفئة $category: $e');
    }
  }

  // Get all categories for a specific restaurant
  Future<List<String>> getCategoriesByRestaurant(String restaurantId) async {
    try {
      final response = await _supabase
          .from('menu_items')
          .select('category')
          .eq('restaurant_id', restaurantId)
          .eq('is_available', true)
          .not('category', 'is', null);

      final categories = (response as List)
          .map((item) => item['category'] as String?)
          .where((category) => category != null && category.isNotEmpty)
          .cast<String>()
          .toSet()
          .toList();

      categories.sort();
      return categories;
    } catch (e) {
      throw Exception('فشل في تحميل فئات القائمة: $e');
    }
  }

  // Get menu items grouped by category
  Future<Map<String, List<MenuItem>>> getMenuItemsGroupedByCategory(
      String restaurantId) async {
    try {
      final menuItems = await getMenuItemsByRestaurant(restaurantId);
      final Map<String, List<MenuItem>> groupedItems = {};

      for (final item in menuItems) {
        final category = item.category ?? 'أخرى';
        if (!groupedItems.containsKey(category)) {
          groupedItems[category] = [];
        }
        groupedItems[category]!.add(item);
      }

      // Sort categories
      final sortedKeys = groupedItems.keys.toList()..sort();
      final Map<String, List<MenuItem>> sortedGroupedItems = {};
      for (final key in sortedKeys) {
        sortedGroupedItems[key] = groupedItems[key]!;
      }

      return sortedGroupedItems;
    } catch (e) {
      throw Exception('فشل في تجميع عناصر القائمة: $e');
    }
  }

  // Search menu items by name
  Future<List<MenuItem>> searchMenuItems(
      String restaurantId, String query) async {
    try {
      final response = await _supabase
          .from('menu_items')
          .select('*')
          .eq('restaurant_id', restaurantId)
          .eq('is_available', true)
          // TODO: Fix search functionality
           // .textSearch('name', query)
          .order('name', ascending: true);

      return (response as List)
          .map((item) => MenuItem.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('فشل في البحث عن عناصر القائمة: $e');
    }
  }

  // Get a specific menu item by ID
  Future<MenuItem?> getMenuItemById(String itemId) async {
    try {
      final response = await _supabase
          .from('menu_items')
          .select('*')
          .eq('id', itemId)
          .eq('is_available', true)
          .maybeSingle();

      if (response == null) return null;
      return MenuItem.fromJson(response);
    } catch (e) {
      throw Exception('فشل في تحميل عنصر القائمة: $e');
    }
  }

  // Get menu items by price range
  Future<List<MenuItem>> getMenuItemsByPriceRange(
      String restaurantId, double minPrice, double maxPrice) async {
    try {
      final response = await _supabase
          .from('menu_items')
          .select('*')
          .eq('restaurant_id', restaurantId)
          .eq('is_available', true)
          .gte('price', minPrice)
          .lte('price', maxPrice)
          .order('price', ascending: true);

      return (response as List)
          .map((item) => MenuItem.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('فشل في تحميل عناصر القائمة بالسعر المحدد: $e');
    }
  }

  // Get popular menu items (this would require additional logic based on orders)
  Future<List<MenuItem>> getPopularMenuItems(String restaurantId,
      {int limit = 10}) async {
    try {
      // For now, we'll return items ordered by creation date
      // In a real app, you might want to order by popularity metrics
      final response = await _supabase
          .from('menu_items')
          .select('*')
          .eq('restaurant_id', restaurantId)
          .eq('is_available', true)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((item) => MenuItem.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('فشل في تحميل العناصر الشائعة: $e');
    }
  }

  // Get menu statistics for a restaurant
  Future<Map<String, dynamic>> getMenuStatistics(String restaurantId) async {
    try {
      final menuItems = await getMenuItemsByRestaurant(restaurantId);
      final categories = await getCategoriesByRestaurant(restaurantId);

      double totalPrice = 0;
      double minPrice = double.infinity;
      double maxPrice = 0;

      for (final item in menuItems) {
        totalPrice += item.price;
        if (item.price < minPrice) minPrice = item.price;
        if (item.price > maxPrice) maxPrice = item.price;
      }

      final averagePrice = menuItems.isNotEmpty ? totalPrice / menuItems.length : 0;

      return {
        'total_items': menuItems.length,
        'total_categories': categories.length,
        'average_price': averagePrice,
        'min_price': minPrice == double.infinity ? 0 : minPrice,
        'max_price': maxPrice,
        'categories': categories,
      };
    } catch (e) {
      throw Exception('فشل في تحميل إحصائيات القائمة: $e');
    }
  }

  // Admin/Owner functions (require proper authentication)
  
  // Add a new menu item (for restaurant owners/admins)
  Future<MenuItem?> addMenuItem(MenuItem menuItem) async {
    try {
      final response = await _supabase
          .from('menu_items')
          .insert(menuItem.toInsertJson())
          .select()
          .single();

      return MenuItem.fromJson(response);
    } catch (e) {
      throw Exception('فشل في إضافة عنصر القائمة: $e');
    }
  }

  // Update a menu item (for restaurant owners/admins)
  Future<MenuItem?> updateMenuItem(String itemId, Map<String, dynamic> updates) async {
    try {
      final response = await _supabase
          .from('menu_items')
          .update(updates)
          .eq('id', itemId)
          .select()
          .single();

      return MenuItem.fromJson(response);
    } catch (e) {
      throw Exception('فشل في تحديث عنصر القائمة: $e');
    }
  }

  // Delete a menu item (for restaurant owners/admins)
  Future<bool> deleteMenuItem(String itemId) async {
    try {
      await _supabase
          .from('menu_items')
          .delete()
          .eq('id', itemId);
      return true;
    } catch (e) {
      throw Exception('فشل في حذف عنصر القائمة: $e');
    }
  }

  // Toggle availability of a menu item
  Future<bool> toggleMenuItemAvailability(String itemId, bool isAvailable) async {
    try {
      await _supabase
          .from('menu_items')
          .update({'is_available': isAvailable})
          .eq('id', itemId);
      return true;
    } catch (e) {
      throw Exception('فشل في تغيير حالة توفر العنصر: $e');
    }
  }
}