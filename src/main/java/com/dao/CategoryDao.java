package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.dto.Category;
import com.util.DBConnection;

/**
 * Data Access Object for Category entity
 * Handles all database operations related to categories
 */
public class CategoryDao {

    // SQL Queries
    private static final String INSERT_CATEGORY = "INSERT INTO categories (name, description, icon) VALUES (?, ?, ?)";
    private static final String GET_CATEGORY_BY_ID = "SELECT * FROM categories WHERE id = ?";
    private static final String GET_CATEGORY_BY_NAME = "SELECT * FROM categories WHERE name = ?";
    private static final String GET_ALL_CATEGORIES = "SELECT * FROM categories ORDER BY name";
    private static final String GET_ACTIVE_CATEGORIES = "SELECT * FROM categories WHERE is_active = 1 ORDER BY name";
    private static final String UPDATE_CATEGORY = "UPDATE categories SET name = ?, description = ?, icon = ?, is_active = ? WHERE id = ?";
    private static final String DELETE_CATEGORY = "DELETE FROM categories WHERE id = ?";
    private static final String GET_CATEGORY_COUNT = "SELECT COUNT(*) FROM categories";

    /**
     * Add a new category
     */
    public boolean addCategory(Category category) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(INSERT_CATEGORY, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, category.getName());
            pstmt.setString(2, category.getDescription());
            pstmt.setString(3, category.getIcon());
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    category.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get category by ID
     */
    public Category getCategoryById(int id) {
        Category category = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_CATEGORY_BY_ID)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                category = extractCategoryFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return category;
    }

    /**
     * Get category by name
     */
    public Category getCategoryByName(String name) {
        Category category = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(GET_CATEGORY_BY_NAME)) {
            
            pstmt.setString(1, name);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                category = extractCategoryFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return category;
    }

    /**
     * Get all categories
     */
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(GET_ALL_CATEGORIES)) {
            
            while (rs.next()) {
                categories.add(extractCategoryFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

    /**
     * Get all active categories
     */
    public List<Category> getActiveCategories() {
        List<Category> categories = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(GET_ACTIVE_CATEGORIES)) {
            
            while (rs.next()) {
                categories.add(extractCategoryFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

    /**
     * Update category
     */
    public boolean updateCategory(Category category) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(UPDATE_CATEGORY)) {
            
            pstmt.setString(1, category.getName());
            pstmt.setString(2, category.getDescription());
            pstmt.setString(3, category.getIcon());
            pstmt.setBoolean(4, category.isActive());
            pstmt.setInt(5, category.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete category
     */
    public boolean deleteCategory(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(DELETE_CATEGORY)) {
            
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get total category count
     */
    public int getCategoryCount() {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(GET_CATEGORY_COUNT)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Check if category name already exists
     */
    public boolean nameExists(String name) {
        return getCategoryByName(name) != null;
    }

    /**
     * Helper method to extract Category from ResultSet
     */
    private Category extractCategoryFromResultSet(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setId(rs.getInt("id"));
        category.setName(rs.getString("name"));
        category.setDescription(rs.getString("description"));
        category.setIcon(rs.getString("icon"));
        category.setActive(rs.getBoolean("is_active"));
        category.setCreatedAt(rs.getTimestamp("created_at"));
        return category;
    }
}
