import React from 'react';
import { Outlet } from 'react-router';
import { Provider } from 'react-redux';
import { store } from '../state/store';
import { SoundToggle } from '../components/SoundToggle/SoundToggle';
import '@fontsource-variable/inter';
import '../fonts.css';
import '../index.css';
import './extension.css';

export function ExtensionLayout() {
  return (
    <Provider store={store}>
      <div className="extension-container">
        <SoundToggle />
        <Outlet />
      </div>
    </Provider>
  );
}
