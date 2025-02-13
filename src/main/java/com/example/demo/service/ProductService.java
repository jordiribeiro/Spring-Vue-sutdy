package com.example.demo.service;

import com.example.demo.entity.Product;
import java.util.List;
import java.util.Optional;

public interface ProductService {
    Product createProduct(Product product);
    Optional<Product> getProductById(Long id);
    List<Product> getAllProducts();
    Product updateProduct(Long id, Product product);     // Replace entire product
    Product patchProduct(Long id, Product product);      // Partial update
    void deleteProduct(Long id);
} 