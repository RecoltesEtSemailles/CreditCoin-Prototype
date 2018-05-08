contract Escrow is SafeMath{

    // address of the content creator
  	address public beneficiary;

    // release first token supply after milestone reached
  	bool private firstMilestone = false;

    // release tokens after reaching other milestones 
  	uint256 public secondMilestone;
  	uint256 public thirdMilestone;
  	
  	// check periodic releases
    bool private firstMilestoneFinished = false;
    bool private secondMilestoneFinished = false;
    
  	Token public ERC20Token;

  	enum Phases{
      	firstMilestone,
      	secondMilestone,
      	thirdMilestone
  	}

  	Phases public phase = Phases.firstMilestone;

  	modifier atPhase(Phases _phase){
      	if(phase == _phase) _;
  	}
  	
  	event Deposit(address indexed depositer, address _token, uint  amount);

  	function Escrow(address _token){
      	require(_token != address(0));
      	beneficiary = msg.sender;
      	ERC20Token = Token(_token);
  	}

  	function changeBeneficiary(address newBeneficiary) external{
      	require(newBeneficiary != address(0));
      	require(msg.sender == beneficiary);
      	beneficiary = newBeneficiary;
  	}

  	function checkBalance() constant returns (uint256 tokenBalance){
      	return ERC20Token.balanceOf(this);
  	}
  	
   	function deposit(uint256 amount) {
         ERC20Token.approve(msg.sender, amount);
         ERC20Token.transferFrom(msg.sender, this, amount);
         Deposit(msg.sender, ERC20Token, amount);
     }

  	function withdrawal() external{
      	require(msg.sender == beneficiary);
      	//require(block.number > icoEndBlock);
      	uint256 balance = ERC20Token.balanceOf(this);
      	third_milestone(balance);
      	second_milestone(balance);
      	first_milestone(balance);
  	}

  	function nextPhase() private{
      	phase = Phases(uint256(phase) + 1);
  	}

    // first_milestone releases 1/3 of tokens
  	function first_milestone(uint256 balance) private atPhase(Phases.firstMilestone){
      	// add conditioning
      	uint256 amountToTransfer = safeDiv(safeMul(balance, 333), 1000);
      	ERC20Token.transfer(beneficiary, amountToTransfer);
      	nextPhase();
  	}
 	 
  	function second_milestone(uint256 balance) private atPhase(Phases.secondMilestone){
      	require(now > secondMilestone);
      	uint256 amountToTransfer = balance / 2;
      	ERC20Token.transfer(beneficiary, amountToTransfer);
      	nextPhase();
  	}
 	 
  	function third_milestone(uint256 balance) private atPhase(Phases.thirdMilestone){
      	require(now > thirdMilestone);
      	ERC20Token.transfer(beneficiary, balance);
  	}

  	function withdrawOtherCCOIN(address _token) external{
      	require(msg.sender == beneficiary);
      	require(_token != address(0));
      	Token token = Token(_token);
      	require(token != ERC20Token);
      	uint256 balance = token.balanceOf(this);
      	token.transfer(beneficiary, balance);
   	}
 }
