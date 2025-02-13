   package com.example.demo.controller;
   
   import org.springframework.stereotype.Controller;
   import org.springframework.web.bind.annotation.RequestMapping;
   
   @Controller
   public class IndexController {
       // Match anything that is not an API request and forward it to index.html
       @RequestMapping(value = { "/", "/{[path:[^\\.]*}" })
       public String index() {
           return "forward:/index.html";
       }
   }