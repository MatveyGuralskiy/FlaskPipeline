import unittest
from app import app

class TestApp(unittest.TestCase):
    
    def setUp(self):
        self.app = app.test_client()

    # Check the Main Page    
    def test_index(self):
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'<h1>FlaskPipeline Project</h1>', response.data)
    
    # Check the Page About
    def test_about(self):
        response = self.app.get('/about')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'<h1>About me</h1>', response.data)
    
    # Check the Page Register
    def test_register(self):
        response = self.app.get('/register')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'<h1>Sign Up</h1>', response.data)

if __name__ == '__main__':
    unittest.main(testRunner=unittest.TextTestRunner())