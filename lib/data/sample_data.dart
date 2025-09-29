import '../models/adventure.dart';
import '../models/media_item.dart';

// Sample data for demonstration
// Replace these with your actual photos and videos!
class SampleData {
  static List<Adventure> getAdventures() {
    return [
      Adventure(
        id: '1',
        title: 'Beach Escape',
        description: 'Amazing weekend at the beach with friends',
        date: DateTime(2025, 8, 15),
        location: 'Malibu, California',
        coverImage:
            'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
        mediaItems: [
          MediaItem(
            id: '1',
            path:
                'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
            type: MediaType.image,
            date: DateTime(2025, 8, 15),
            description: 'Sunset at the beach',
            location: 'Malibu Beach',
          ),
          MediaItem(
            id: '2',
            path:
                'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=800',
            type: MediaType.image,
            date: DateTime(2025, 8, 15),
            description: 'Beach vibes',
          ),
          MediaItem(
            id: '3',
            path:
                'https://images.unsplash.com/photo-1473496169904-658ba7c44d8a?w=800',
            type: MediaType.image,
            date: DateTime(2025, 8, 15),
          ),
        ],
      ),
      Adventure(
        id: '2',
        title: 'Mountain Hiking',
        description: 'Epic mountain adventure and breathtaking views',
        date: DateTime(2025, 7, 10),
        location: 'Rocky Mountains',
        coverImage:
            'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
        mediaItems: [
          MediaItem(
            id: '4',
            path:
                'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
            type: MediaType.image,
            date: DateTime(2025, 7, 10),
            description: 'Summit view',
          ),
          MediaItem(
            id: '5',
            path:
                'https://images.unsplash.com/photo-1454496522488-7a8e488e8606?w=800',
            type: MediaType.image,
            date: DateTime(2025, 7, 10),
          ),
          MediaItem(
            id: '6',
            path:
                'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800',
            type: MediaType.image,
            date: DateTime(2025, 7, 10),
          ),
          MediaItem(
            id: '7',
            path:
                'https://images.unsplash.com/photo-1483728642387-6c3bdd6c93e5?w=800',
            type: MediaType.image,
            date: DateTime(2025, 7, 10),
          ),
        ],
      ),
      Adventure(
        id: '3',
        title: 'City Exploration',
        description: 'Weekend wandering through the city streets',
        date: DateTime(2025, 6, 20),
        location: 'New York City',
        coverImage:
            'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=800',
        mediaItems: [
          MediaItem(
            id: '8',
            path:
                'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=800',
            type: MediaType.image,
            date: DateTime(2025, 6, 20),
          ),
          MediaItem(
            id: '9',
            path:
                'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800',
            type: MediaType.image,
            date: DateTime(2025, 6, 20),
          ),
          MediaItem(
            id: '10',
            path:
                'https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=800',
            type: MediaType.image,
            date: DateTime(2025, 6, 20),
          ),
        ],
      ),
      Adventure(
        id: '4',
        title: 'Desert Road Trip',
        description: 'Road trip through stunning desert landscapes',
        date: DateTime(2025, 5, 5),
        location: 'Arizona Desert',
        coverImage:
            'https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=800',
        mediaItems: [
          MediaItem(
            id: '11',
            path:
                'https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=800',
            type: MediaType.image,
            date: DateTime(2025, 5, 5),
          ),
          MediaItem(
            id: '12',
            path:
                'https://images.unsplash.com/photo-1518709594023-6eab9bab7b23?w=800',
            type: MediaType.image,
            date: DateTime(2025, 5, 5),
          ),
        ],
      ),
      Adventure(
        id: '5',
        title: 'Forest Camping',
        description: 'Peaceful camping weekend in the woods',
        date: DateTime(2025, 4, 12),
        location: 'Pacific Northwest',
        coverImage:
            'https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?w=800',
        mediaItems: [
          MediaItem(
            id: '13',
            path:
                'https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?w=800',
            type: MediaType.image,
            date: DateTime(2025, 4, 12),
          ),
          MediaItem(
            id: '14',
            path:
                'https://images.unsplash.com/photo-1501555088652-021faa106b9b?w=800',
            type: MediaType.image,
            date: DateTime(2025, 4, 12),
          ),
          MediaItem(
            id: '15',
            path:
                'https://images.unsplash.com/photo-1511497584788-876760111969?w=800',
            type: MediaType.image,
            date: DateTime(2025, 4, 12),
          ),
        ],
      ),
    ];
  }
}
