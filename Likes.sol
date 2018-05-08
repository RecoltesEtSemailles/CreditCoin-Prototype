contract Likes {
    
    struct Liker {
        address likerAddress;
        bytes16 firstName;
        bytes16 lastName;
    }
    
    mapping (address => Liker) likes;
    address[] public likeAccts;
    
    event likerInfo(address likerAddress, bytes16 firstName, bytes16 lastName);
    
    function giveLike(bytes16 _firstName, bytes16 _lastName) public {
        var like = likes[msg.sender];
        
        like.firstName = _firstName;
        like.lastName = _lastName;
        
        likeAccts.push(msg.sender) -1;
        emit likerInfo(msg.sender, _firstName, _lastName);
    }
    
    function getLikers() view public returns(address[]) {
        return likeAccts;
    }
    
    function getLiker(address _address) view public returns (string, string) {
        return (bytes32ToString(likes[_address].firstName), bytes32ToString(likes[_address].lastName));
    }
    
    function likesCount() view public returns (uint) {
        return likeAccts.length;
    }
    
    function bytes32ToString(bytes32 x) private constant returns (string) {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }
}
