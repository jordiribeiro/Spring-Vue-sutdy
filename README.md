# Product CRUD Application

This repository contains a full-stack CRUD application built with Spring Boot and Vue.js following SOLID development principles. The application demonstrates a layered design with separate concerns for the backend (Spring Boot, Spring Data JPA, H2) and the frontend (Vue.js).

## Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Backend Setup](#backend-setup)
- [Frontend Setup](#frontend-setup)
- [Usage](#usage)
- [API Endpoints](#api-endpoints)
- [License](#license)

## Features

- **CRUD Operations:** Create, read, update (full & partial), and delete products.
- **Spring Boot Backend:** RESTful API built using Spring Boot, following SOLID principles with a clear separation between controller, service, and repository layers.
- **In-Memory Database:** Uses H2, which allows you to run the app without additional database setup.
- **Vue.js Frontend:** Provides a dynamic single-page interface for managing products.

## Project Structure 
├── README.md # This file
├── pom.xml # Maven build file for the Spring Boot app
├── src
│ ├── main
│ │ ├── java
│ │ │ └── com
│ │ │ └── example
│ │ │ └── demo
│ │ │ ├── DemoApplication.java # Spring Boot entry point
│ │ │ ├── controller
│ │ │ │ └── ProductController.java # REST Controller exposing API endpoints
│ │ │ ├── entity
│ │ │ │ └── Product.java # JPA Entity representing the product
│ │ │ ├── repository
│ │ │ │ └── ProductRepository.java # Repository interface for products
│ │ │ └── service
│ │ │ ├── ProductService.java # Service interface
│ │ │ └── ProductServiceImpl.java # Service implementation
│ │ └── resources
│ │ └── application.properties # Configurations including H2 settings
└── frontend
└── ProductCrud.vue # Vue.js component for CRUD operations


## Prerequisites

### Backend

- Java 11 or later
- Maven

### Frontend

- Node.js and npm (if using Vue CLI, Vite, or a similar setup)
- Vue.js 3

## Backend Setup

1. **Clone the Repository:**

   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Build and Run the Spring Boot Application:**

   From the project root, run:

   ```bash
   mvn clean spring-boot:run
   ```

   The backend will start on [http://localhost:8080](http://localhost:8080).

3. **Access the H2 Database Console (Optional):**

   Navigate to [http://localhost:8080/h2-console](http://localhost:8080/h2-console) in your browser and use the following settings:

   - **JDBC URL:** `jdbc:h2:mem:testdb`
   - **User Name:** `sa`
   - **Password:** *(leave blank)*

## Frontend Setup

1. **Integrate the Vue.js Component:**

   Copy `ProductCrud.vue` from the `frontend` folder into your Vue.js project's `src/components` directory. If you don't have a Vue project set up, you can create one using Vue CLI:

   ```bash
   vue create my-vue-app
   cd my-vue-app
   ```

2. **Update Your App Component:**

   Modify `src/App.vue` to use the `ProductCrud` component:

   ```vue
   <template>
     <div id="app">
       <ProductCrud />
     </div>
   </template>

   <script>
   import ProductCrud from './components/ProductCrud.vue';

   export default {
     name: 'App',
     components: {
       ProductCrud
     }
   };
   </script>
   ```

3. **Run the Vue.js Application:**

   In the Vue project directory, run:

   ```bash
   npm run serve
   ```

   Your Vue.js app will typically be available at [http://localhost:8081](http://localhost:8081) or another port. Make sure that the `API_URL` in `ProductCrud.vue` is set to `http://localhost:8080/api/products` so that it can communicate with the Spring Boot backend.

## Usage

1. **Start the Servers:**

   - **Backend:** Run the Spring Boot application with Maven.
   - **Frontend:** Run your Vue.js app with the appropriate npm command.

2. **Access the Application:**

   Open your browser and navigate to the URL where your Vue.js app is running.

3. **Perform CRUD Operations:**

   - **Create:** Enter product details in the form and click the "Create" button.
   - **Read:** The list of products is displayed on the page.
   - **Replace (Update):** Click the "Edit (Replace)" button next to a product to populate the form for a full update. Modify the details and submit the form.
   - **Partial Update (Patch):** Click the "Patch Update" button to apply a partial update (e.g., modify the product name by prepending "Patched: ").
   - **Delete:** Click the "Delete" button to remove the product.

## API Endpoints

The Spring Boot backend exposes the following endpoints:

- `GET /api/products` – Retrieve all products.
- `GET /api/products/{id}` – Retrieve a product by its ID.
- `POST /api/products` – Create a new product.
- `PUT /api/products/{id}` – Replace (update) an existing product.
- `PATCH /api/products/{id}` – Partially update an existing product.
- `DELETE /api/products/{id}` – Delete a product.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.