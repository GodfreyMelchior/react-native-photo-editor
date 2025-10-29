import React, { useState } from 'react';
import {
  SafeAreaView,
  Text,
  StyleSheet,
  Dimensions,
  TouchableOpacity,
  Image,
  View,
} from 'react-native';
import PhotoEditor from '@baronha/react-native-photo-editor';

const { width } = Dimensions.get('window');

const stickers = [
  'https://cdn-icons-png.flaticon.com/512/5272/5272912.png',
  'https://cdn-icons-png.flaticon.com/512/5272/5272913.png',
];

const SimpleApp = () => {
  const [photo, setPhoto] = useState(null);
  const remoteURL =
    'https://images.unsplash.com/photo-1634915728822-5ad85582837a?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=774&q=80';

  const onEdit = async () => {
    try {
      const path = await PhotoEditor.open({
        path: photo || remoteURL,
        stickers,
      });
      setPhoto(path);
      console.log('Edited photo path:', path);
    } catch (e) {
      console.log('Photo Editor Error:', e);
    }
  };

  return (
    <SafeAreaView style={style.container}>
      <View style={style.header}>
        <Text style={style.title}>Photo Editor Test</Text>
        <Text style={style.subtitle}>Tap the image to edit it</Text>
        <Text style={style.features}>✓ Crop ✓ Rotate ✓ Filters ✓ Drawing ✓ Text</Text>
      </View>

      <TouchableOpacity onPress={onEdit} style={style.imageContainer}>
        <Image
          style={style.image}
          source={{
            uri: photo || remoteURL,
          }}
          resizeMode="cover"
        />
        <View style={style.overlay}>
          <Text style={style.overlayText}>TAP TO EDIT</Text>
        </View>
      </TouchableOpacity>

      <View style={style.infoBox}>
        <Text style={style.infoTitle}>New Features Added:</Text>
        <Text style={style.infoText}>• Crop Tool - Free aspect ratio cropping</Text>
        <Text style={style.infoText}>• Rotate Tool - 90° clockwise rotation</Text>
      </View>
    </SafeAreaView>
  );
};

export default SimpleApp;

const style = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#1a1a1a',
  },
  header: {
    padding: 20,
    alignItems: 'center',
    backgroundColor: '#2a2a2a',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#fff',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: '#888',
    marginBottom: 4,
  },
  features: {
    fontSize: 14,
    color: '#4CAF50',
    marginTop: 8,
  },
  imageContainer: {
    width,
    height: width,
    backgroundColor: '#000',
    position: 'relative',
  },
  image: {
    width: '100%',
    height: '100%',
  },
  overlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(0,0,0,0.3)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  overlayText: {
    color: '#fff',
    fontSize: 20,
    fontWeight: 'bold',
    backgroundColor: 'rgba(0,0,0,0.5)',
    padding: 12,
    borderRadius: 8,
  },
  infoBox: {
    margin: 20,
    padding: 16,
    backgroundColor: '#2a2a2a',
    borderRadius: 8,
    borderLeftWidth: 4,
    borderLeftColor: '#4CAF50',
  },
  infoTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#fff',
    marginBottom: 12,
  },
  infoText: {
    fontSize: 14,
    color: '#ccc',
    marginBottom: 8,
  },
});
