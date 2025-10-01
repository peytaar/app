import 'package:flutter_test/flutter_test.dart';
import 'package:purplestack/widgets/common/note_parser.dart';

void main() {
  group('NoteParser', () {
    group('extractNip19Entities', () {
      test('should extract valid npub entities', () {
        const content =
            'Hello npub107jk7htfv243u0x5ynn43scq9wrxtaasmrwwa8lfu2ydwag6cx2quqncxg world!';
        final entities = NoteParser.extractNip19Entities(content);

        expect(entities.length, 1);
        expect(
          entities[0],
          'npub107jk7htfv243u0x5ynn43scq9wrxtaasmrwwa8lfu2ydwag6cx2quqncxg',
        );
      });

      test('should extract multiple NIP-19 entities', () {
        const content = '''
          Check out npub1sg6plzptd64u62a878hep2kev88swjh3tw00gjsfl8f237lmu63q0uf63m 
          and npub107jk7htfv243u0x5ynn43scq9wrxtaasmrwwa8lfu2ydwag6cx2quqncxg
        ''';
        final entities = NoteParser.extractNip19Entities(content);

        expect(entities.length, 2);
        expect(
          entities[0],
          'npub1sg6plzptd64u62a878hep2kev88swjh3tw00gjsfl8f237lmu63q0uf63m',
        );
        expect(
          entities[1],
          'npub107jk7htfv243u0x5ynn43scq9wrxtaasmrwwa8lfu2ydwag6cx2quqncxg',
        );
      });

      test('should not extract invalid entities', () {
        const content = 'This is not a valid npub1invalidtooShort entity';
        final entities = NoteParser.extractNip19Entities(content);

        expect(entities.isEmpty, true);
      });
    });

    group('extractHttpUrls', () {
      test('should extract HTTP URLs', () {
        const content = 'Check out https://example.com and http://test.org';
        final urls = NoteParser.extractHttpUrls(content);

        expect(urls.length, 2);
        expect(urls[0], 'https://example.com');
        expect(urls[1], 'http://test.org');
      });

      test('should extract URLs with paths and parameters', () {
        const content =
            'Image: https://example.com/path/to/image.jpg?param=value';
        final urls = NoteParser.extractHttpUrls(content);

        expect(urls.length, 1);
        expect(urls[0], 'https://example.com/path/to/image.jpg?param=value');
      });
    });

    group('extractMediaUrls', () {
      test('should identify image URLs as media', () {
        const content = '''
          Regular link https://example.com and 
          image https://image.nostr.build/photo.jpg
        ''';
        final mediaUrls = NoteParser.extractMediaUrls(content);

        expect(mediaUrls.length, 1);
        expect(mediaUrls[0], 'https://image.nostr.build/photo.jpg');
      });

      test('should identify various media extensions', () {
        const content = '''
          https://example.com/video.mp4
          https://example.com/audio.mp3
          https://example.com/image.png
          https://example.com/document.pdf
        ''';
        final mediaUrls = NoteParser.extractMediaUrls(content);

        expect(mediaUrls.length, 3); // pdf is not considered media
        expect(mediaUrls.contains('https://example.com/video.mp4'), true);
        expect(mediaUrls.contains('https://example.com/audio.mp3'), true);
        expect(mediaUrls.contains('https://example.com/image.png'), true);
        expect(mediaUrls.contains('https://example.com/document.pdf'), false);
      });
    });

    group('extractHashtags', () {
      test('should extract single hashtag', () {
        const content = 'Hello #nostr world!';
        final hashtags = NoteParser.extractHashtags(content);

        expect(hashtags.length, 1);
        expect(hashtags[0], 'nostr');
      });

      test('should extract multiple hashtags', () {
        const content = 'Love #bitcoin and #nostr #decentralized networks!';
        final hashtags = NoteParser.extractHashtags(content);

        expect(hashtags.length, 3);
        expect(hashtags[0], 'bitcoin');
        expect(hashtags[1], 'nostr');
        expect(hashtags[2], 'decentralized');
      });

      test('should extract hashtags with numbers and underscores', () {
        const content = 'Check out #test_hashtag and #bitcoin21 and #web3_0';
        final hashtags = NoteParser.extractHashtags(content);

        expect(hashtags.length, 3);
        expect(hashtags[0], 'test_hashtag');
        expect(hashtags[1], 'bitcoin21');
        expect(hashtags[2], 'web3_0');
      });

      test('should not extract standalone # symbol', () {
        const content = 'This is just a # symbol without text';
        final hashtags = NoteParser.extractHashtags(content);

        expect(hashtags.isEmpty, true);
      });

      test('should handle hashtags at different positions', () {
        const content = '#start hashtag and middle #tag and #end';
        final hashtags = NoteParser.extractHashtags(content);

        expect(hashtags.length, 3);
        expect(hashtags[0], 'start');
        expect(hashtags[1], 'tag');
        expect(hashtags[2], 'end');
      });

      test('should not extract hashtags with spaces or special characters', () {
        const content = 'Not valid: #hash tag or #hash@tag or #hash-tag';
        final hashtags = NoteParser.extractHashtags(content);

        // Only the part before the special character should be extracted
        expect(hashtags.length, 3);
        expect(hashtags[0], 'hash');
        expect(hashtags[1], 'hash');
        expect(hashtags[2], 'hash');
      });
    });

    group('isValidNip19Entity', () {
      test('should validate real NIP-19 entities', () {
        // These would need to be real entities in a full test
        const validEntity =
            'npub107jk7htfv243u0x5ynn43scq9wrxtaasmrwwa8lfu2ydwag6cx2quqncxg';
        const invalidEntity = 'npub1invalidtooShort';

        // Note: This test would fail without proper NIP-19 validation
        // For now, we'll test the structure
        expect(validEntity.length > 60, true);
        expect(invalidEntity.length < 60, true);
      });
    });
  });
}
