// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title GeoReviews
 * @dev Этот контракт хранит отзывы, привязанные к географическим координатам.
 * Координаты используются в виде строкового ключа (например, "51.505,-0.090").
 */
contract GeoReviews {

    // Структура для хранения одного отзыва
    struct Review {
        address user;           // Адрес кошелька, оставившего отзыв
        string institutionName; // Название учреждения
        string message;         // Текст отзыва
        uint8 rating;           // Оценка (например, от 1 до 5)
        uint256 timestamp;      // Время создания
    }

    // Событие, которое будет срабатывать при добавлении нового отзыва
    // Это удобно для отслеживания на фронтенде (хотя мы будем просто перезагружать)
    event ReviewAdded(
        address indexed user,
        string indexed locationId,
        string institutionName,
        uint8 rating
    );

    // Основное хранилище:
    // Сопоставление "ID локации" (строка) с массивом отзывов
    mapping(string => Review[]) public reviewsByLocation;

    /**
     * @dev Добавляет новый отзыв для указанной локации.
     * @param _locationId Строковый идентификатор локации (например, "42.87460,74.56976")
     * @param _institutionName Название учреждения
     * @param _message Текст отзыва
     * @param _rating Оценка от 1 до 5
     */
    function addReview(
        string memory _locationId,
        string memory _institutionName,
        string memory _message,
        uint8 _rating
    ) public {
        // Простая проверка: оценка должна быть в допустимом диапазоне
        require(_rating >= 1 && _rating <= 5, "Rating must be between 1 and 5");

        // Создаем новый отзыв в памяти
        Review memory newReview = Review({
            user: msg.sender, // msg.sender - это адрес, вызвавший функцию
            institutionName: _institutionName,
            message: _message,
            rating: _rating,
            timestamp: block.timestamp // Текущее время в блокчейне
        });

        // Добавляем отзыв в массив, связанный с этой локацией
        reviewsByLocation[_locationId].push(newReview);

        // Сообщаем о событии
        emit ReviewAdded(
            msg.sender,
            _locationId,
            _institutionName,
            _rating
        );
    }

    /**
     * @dev Возвращает все отзывы для указанной локации.
     * Это 'view' функция, она не тратит газ (бесплатна для вызова).
     * @param _locationId Строковый идентификатор локации
     * @return Массив отзывов
     */
    function getReviews(string memory _locationId)
        public
        view
        returns (Review[] memory)
    {
        return reviewsByLocation[_locationId];
    }
}