<template>
  <div>
    <h1>Products CRUD</h1>
    <!-- Product Form: used to create or replace a product -->
    <form @submit.prevent="handleSubmit">
      <div>
        <label for="name">Name</label>
        <input type="text" id="name" v-model="form.name" required />
      </div>
      <div>
        <label for="price">Price</label>
        <input type="number" id="price" v-model.number="form.price" required />
      </div>
      <div>
        <button type="submit">{{ form.id ? "Update (Replace)" : "Create" }}</button>
        <button type="button" v-if="form.id" @click="resetForm">Cancel</button>
      </div>
    </form>

    <!-- List of Products -->
    <table border="1" cellspacing="0" cellpadding="5">
      <thead>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>Price</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="product in products" :key="product.id">
          <td>{{ product.id }}</td>
          <td>{{ product.name }}</td>
          <td>{{ product.price }}</td>
          <td>
            <button @click="editProduct(product)">Edit (Replace)</button>
            <button @click="patchProduct(product)">Patch Update</button>
            <button @click="deleteProduct(product.id)">Delete</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const API_URL = "http://localhost:8080/api/products";
const products = ref([]);
const form = ref({
  id: null,
  name: '',
  price: 0,
});

// Fetch the list of products from the backend
const fetchProducts = async () => {
  try {
    const response = await fetch(API_URL);
    products.value = await response.json();
  } catch (error) {
    console.error("Error fetching products:", error);
  }
};

onMounted(() => {
  fetchProducts();
});

// Handle form submission for create or full update (replace)
const handleSubmit = async () => {
  if (form.value.id) {
    // Replace existing product via PUT
    try {
      const response = await fetch(`${API_URL}/${form.value.id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: form.value.name, price: form.value.price })
      });
      if (response.ok) {
        await fetchProducts();
        resetForm();
      }
    } catch (error) {
      console.error("Update error", error);
    }
  } else {
    // Create new product via POST
    try {
      const response = await fetch(API_URL, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name: form.value.name, price: form.value.price })
      });
      if (response.ok) {
        await fetchProducts();
        resetForm();
      }
    } catch (error) {
      console.error("Create error", error);
    }
  }
};

// Pre-fill the form for editing (replace)
const editProduct = (product) => {
  form.value.id = product.id;
  form.value.name = product.name;
  form.value.price = product.price;
};

// Reset the form
const resetForm = () => {
  form.value.id = null;
  form.value.name = '';
  form.value.price = 0;
};

// Perform a partial update: for demonstration, we patch the name field.
const patchProduct = async (product) => {
  // For the demo, we prepend "Patched: " to the current name if it hasn't been patched yet.
  const newName = product.name.startsWith("Patched:") ? product.name : "Patched: " + product.name;
  try {
    const response = await fetch(`${API_URL}/${product.id}`, {
      method: 'PATCH',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name: newName })
    });
    if (response.ok) {
      await fetchProducts();
    }
  } catch (error) {
    console.error("Patch update error", error);
  }
};

// Delete a product
const deleteProduct = async (id) => {
  try {
    const response = await fetch(`${API_URL}/${id}`, {
      method: 'DELETE'
    });
    if (response.ok) {
      await fetchProducts();
    }
  } catch (error) {
    console.error("Delete error", error);
  }
};
</script>

<style scoped>
/* Basic styling for better presentation */
table {
  margin-top: 20px;
  width: 100%;
}
td, th {
  padding: 8px;
  text-align: left;
}
</style> 