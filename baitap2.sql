CREATE DATABASE IF NOT EXISTS ClinicInventory_DB;
USE ClinicInventory_DB;

-- Tạo bảng kho vật tư
CREATE TABLE Inventory (
    item_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    stock_quantity INT DEFAULT 0
);

INSERT INTO Inventory (item_id, item_name, stock_quantity) 
VALUES (10, 'Khẩu trang N95', 1000);

DELIMITER //
CREATE PROCEDURE AddInventory(IN p_item_id INT, IN p_quantity INT)
BEGIN
    UPDATE Inventory
    SET stock_quantity = stock_quantity + p_quantity
    WHERE item_id = p_item_id;
END //
DELIMITER ;

CALL AddInventory(10, -500);

-- Kiểm tra kết quả: Kho chỉ còn 500 (Sai nghiệp vụ)
SELECT * FROM Inventory WHERE item_id = 10;

DROP PROCEDURE IF EXISTS AddInventory;

DELIMITER //

CREATE PROCEDURE AddInventory(IN p_item_id INT, IN p_quantity INT)
BEGIN
    -- Kiểm tra quy tắc hệ thống: Số lượng nhập kho phải lớn hơn 0
    IF p_quantity > 0 THEN
        UPDATE Inventory
        SET stock_quantity = stock_quantity + p_quantity
        WHERE item_id = p_item_id;
    ELSE
        -- Phát tín hiệu lỗi nếu dữ liệu không hợp lệ
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Lỗi nghiệp vụ: Số lượng nhập kho phải lớn hơn 0.';
    END IF;
END //

DELIMITER ;