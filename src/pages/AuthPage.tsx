import { useState } from 'react';
import Login from '../components/auth/Login';
import Register from '../components/auth/Register';

export default function AuthPage() {
  const [isLogin, setIsLogin] = useState(true);

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-blue-50 flex items-center justify-center px-4">
      <div className="w-full max-w-md">
        <div className="bg-white rounded-2xl shadow-xl p-8">
          {isLogin ? (
            <Login onToggle={() => setIsLogin(false)} />
          ) : (
            <Register onToggle={() => setIsLogin(true)} />
          )}
        </div>
      </div>
    </div>
  );
}
