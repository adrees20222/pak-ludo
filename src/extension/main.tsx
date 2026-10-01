import React from 'react';
import ReactDOM from 'react-dom/client';
import { createHashRouter, RouterProvider } from 'react-router';
import { ExtensionLayout } from './ExtensionLayout';
import HomePage from '../pages/HomePage/HomePage';
import PlayerSetup from '../pages/PlayerSetup/PlayerSetup';
import Play from '../pages/Play/Play';
import HowToPlay from '../pages/HowToPlay/HowToPlay';
import NotFound from '../pages/NotFound/NotFound';
import ErrorBoundary from '../pages/ErrorBoundary/ErrorBoundary';

const router = createHashRouter([
  {
    path: '/',
    element: <ExtensionLayout />,
    errorElement: <ErrorBoundary />,
    children: [
      {
        index: true,
        element: <HomePage />,
      },
      {
        path: 'setup',
        element: <PlayerSetup />,
      },
      {
        path: 'play',
        element: <Play />,
      },
      {
        path: 'how-to-play',
        element: <HowToPlay />,
      },
      {
        path: '*',
        element: <NotFound />,
      },
    ],
  },
]);

const rootElement = document.getElementById('root');
if (rootElement) {
  ReactDOM.createRoot(rootElement).render(
    <React.StrictMode>
      <RouterProvider router={router} />
    </React.StrictMode>
  );
}
