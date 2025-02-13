<template>
    <div class="flex min-h-screen bg-gray-100">
      <!-- Sidebar -->
      <aside class="w-64 bg-white shadow-md p-4 hidden md:block">
        <h1 class="text-xl font-bold text-gray-800 mb-6">Product Dashboard</h1>
        <nav>
          <a href="#" class="block py-2 px-4 text-gray-600 hover:bg-gray-200 rounded">Home</a>
          <a href="#" class="block py-2 px-4 text-gray-600 hover:bg-gray-200 rounded">Products</a>
          <a href="#" class="block py-2 px-4 text-gray-600 hover:bg-gray-200 rounded">About</a>
        </nav>
      </aside>
      
      <!-- Main Content -->
      <div class="flex-1 flex flex-col">
        <!-- Navbar -->
        <header class="bg-white shadow-md p-4 flex justify-between items-center md:hidden">
          <h1 class="text-lg font-bold">Product Dashboard</h1>
          <button @click="toggleNav" class="text-gray-600 focus:outline-none">
            ☰
          </button>
        </header>
        
        <section class="p-6">
          <h2 class="text-2xl font-bold text-gray-800 mb-4">Manage Your Products</h2>
          
          <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <!-- Product List -->
            <div class="md:col-span-2 bg-white p-6 shadow-md rounded-lg">
              <h3 class="text-lg font-semibold mb-4">Product List</h3>
              <table class="w-full border-collapse border border-gray-200">
                <thead>
                  <tr class="bg-gray-100">
                    <th class="border p-2">ID</th>
                    <th class="border p-2">Name</th>
                    <th class="border p-2">Price</th>
                    <th class="border p-2">Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="product in products" :key="product.id" class="hover:bg-gray-50">
                    <td class="border p-2">{{ product.id }}</td>
                    <td class="border p-2">{{ product.name }}</td>
                    <td class="border p-2">${{ product.price }}</td>
                    <td class="border p-2 flex gap-2">
                      <button class="px-3 py-1 bg-blue-500 text-white rounded" @click="editProduct(product)">Edit</button>
                      <button class="px-3 py-1 bg-yellow-500 text-white rounded" @click="patchProduct(product)">Patch</button>
                      <button class="px-3 py-1 bg-red-500 text-white rounded" @click="deleteProduct(product.id)">Delete</button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            
            <!-- Product Form -->
            <div class="bg-white p-6 shadow-md rounded-lg">
              <h3 class="text-lg font-semibold mb-4">{{ form.id ? 'Update Product' : 'Add New Product' }}</h3>
              <form @submit.prevent="handleSubmit">
                <div class="mb-4">
                  <label class="block text-gray-600">Name</label>
                  <input type="text" v-model="form.name" class="w-full border p-2 rounded" required>
                </div>
                <div class="mb-4">
                  <label class="block text-gray-600">Price</label>
                  <input type="number" v-model.number="form.price" class="w-full border p-2 rounded" required>
                </div>
                <div class="flex gap-2">
                  <button type="submit" class="px-4 py-2 bg-green-500 text-white rounded">{{ form.id ? 'Update' : 'Create' }}</button>
                  <button v-if="form.id" @click="resetForm" type="button" class="px-4 py-2 bg-gray-300 text-gray-800 rounded">Cancel</button>
                </div>
              </form>
            </div>
          </div>
        </section>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue';
  
  const API_URL = "/api/products";
  const products = ref([]);
  const form = ref({ id: null, name: '', price: 0 });
  
  const fetchProducts = async () => {
    try {
      const response = await fetch(API_URL);
      products.value = await response.json();
    } catch (error) {
      console.error("Error fetching products:", error);
    }
  };
  
  onMounted(fetchProducts);
  
  const handleSubmit = async () => {
    const method = form.value.id ? 'PUT' : 'POST';
    const url = form.value.id ? `${API_URL}/${form.value.id}` : API_URL;
    try {
      await fetch(url, {
        method,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: form.value.name, price: form.value.price })
      });
      fetchProducts();
      resetForm();
    } catch (error) {
      console.error("Save error:", error);
    }
  };
  
  const editProduct = (product) => {
    form.value = { ...product };
  };
  
  const resetForm = () => {
    form.value = { id: null, name: '', price: 0 };
  };
  
  const patchProduct = async (product) => {
    try {
      await fetch(`${API_URL}/${product.id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: `Patched: ${product.name}` })
      });
      fetchProducts();
    } catch (error) {
      console.error("Patch error:", error);
    }
  };
  
  const deleteProduct = async (id) => {
    try {
      await fetch(`${API_URL}/${id}`, { method: 'DELETE' });
      fetchProducts();
    } catch (error) {
      console.error("Delete error:", error);
    }
  };
  </script>
  
  <style scoped>
  /* Tailwind classes are already included in the template */
  </style>
  