package com.example.demo.controller;

import com.example.demo.entity.Product;
import com.example.demo.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    private final ProductService productService;
    
    @Autowired
    public ProductController(ProductService productService) {
       this.productService = productService;
    }

    @GetMapping
    public ResponseEntity<List<Product>> getAllProducts() {
        List<Product> products = productService.getAllProducts();
        return new ResponseEntity<>(products, HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Product> getProductById(@PathVariable Long id) {
       return productService.getProductById(id)
               .map(product -> new ResponseEntity<>(product, HttpStatus.OK))
               .orElse(new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @PostMapping
    public ResponseEntity<Product> createProduct(@RequestBody Product product) {
       Product createdProduct = productService.createProduct(product);
       return new ResponseEntity<>(createdProduct, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Product> updateProduct(@PathVariable Long id, @RequestBody Product product) {
       try {
           Product updatedProduct = productService.updateProduct(id, product);
           return new ResponseEntity<>(updatedProduct, HttpStatus.OK);
       } catch (RuntimeException ex) {
           return new ResponseEntity<>(HttpStatus.NOT_FOUND);
       }
    }

    @PatchMapping("/{id}")
    public ResponseEntity<Product> patchProduct(@PathVariable Long id, @RequestBody Product product) {
       try {
           Product updatedProduct = productService.patchProduct(id, product);
           return new ResponseEntity<>(updatedProduct, HttpStatus.OK);
       } catch (RuntimeException ex) {
           return new ResponseEntity<>(HttpStatus.NOT_FOUND);
       }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProduct(@PathVariable Long id) {
       try {
           productService.deleteProduct(id);
           return new ResponseEntity<>(HttpStatus.NO_CONTENT);
       } catch (RuntimeException ex) {
           return new ResponseEntity<>(HttpStatus.NOT_FOUND);
       }
    }
} 