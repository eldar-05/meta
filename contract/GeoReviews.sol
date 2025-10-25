pragma solidity ^0.8.17;


contract GeoReviews {
struct Review {
address author;
string placeName;
string text;
int256 lat;
int256 lng; 
uint256 timestamp;
}


Review[] public reviews;


event ReviewAdded(
uint256 indexed id,
address indexed author,
string placeName,
string text,
int256 lat,
int256 lng,
uint256 timestamp
);


function addReview(
string calldata placeName,
string calldata text,
int256 lat,
int256 lng
) external {
reviews.push(Review(msg.sender, placeName, text, lat, lng, block.timestamp));
uint256 id = reviews.length - 1;
emit ReviewAdded(id, msg.sender, placeName, text, lat, lng, block.timestamp);
}


function getReviewsCount() external view returns (uint256) {
return reviews.length;
}


function getReview(uint256 id)
external
view
returns (
address author,
string memory placeName,
string memory text,
int256 lat,
int256 lng,
uint256 timestamp
)
{
require(id < reviews.length, "no such review");
Review storage r = reviews[id];
return (r.author, r.placeName, r.text, r.lat, r.lng, r.timestamp);
}
}