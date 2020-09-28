pragma solidity >=0.4.22 <0.6.0;
contract settlement{
    address public Compensation;
    address public Creditor;
    address public witness;
    uint public publish_time;
    uint public Settlement_price;
    uint public memNum;
    uint public check;
    uint public TermsNum;
    uint public Compensation_check ;
    uint public Creditor_check ;
    uint public witness_check ;
    
    struct mems{
        address mem_address;
        uint publish_time;
    }
    mapping (uint => mems) public membership;
    
    struct Terms{
        address Compensationa;
        address Creditora;
        address witnessa;
        uint publish_time;
        uint price;
    }
    mapping (uint => Terms) public Termship;
    
    modifier priceEqual{
        require(msg.value == Settlement_price* 1 ether);
        _;
    //18 x 0
    }

    modifier onlyAuthor {
        require (msg.sender == Compensation);
        _;
    }
    
    modifier isCompensation{
        bool qual = false;
        for (uint i=1; i <= memNum ;i++){
            if(membership[i].mem_address == msg.sender){
                if(membership[i].mem_address == Compensation)
                    qual =true;
            }
        }
        require(qual==true);
        _;
    }
    
    modifier isCreditor{
        bool qual = false;
        for (uint i=1; i <= memNum ;i++){
            if(membership[i].mem_address == msg.sender){
                if(membership[i].mem_address == Creditor)
                    qual =true;
            }
        }
        require(qual==true);
        _;
    }
    
    modifier iswitness{
        bool qual = false;
        for (uint i=1; i <= memNum ;i++){
            if(membership[i].mem_address == msg.sender){
                if(membership[i].mem_address == witness)
                    qual =true;
            }
        }
        require(qual==true);
        _;
    }
    
    modifier onlyMember{
        bool qual = false;
        for (uint i=1; i <= memNum ;i++){
            if(membership[i].mem_address == msg.sender ){
                if(membership[i].mem_address == Compensation)
                    qual =true;
                if(membership[i].mem_address == Creditor)
                    qual =true;
                if(membership[i].mem_address == witness)
                    qual =true;
            }
        }
        require(qual==true);
        _;
    }

    modifier allcheck{
        bool qual = false;
        if(Compensation_check == 1)
            if(Creditor_check == 1)
                if(witness_check == 1)
                        qual = true;
        require(qual==true);
        _;
    }

    constructor(address _Compensation,address _Creditor,address _witness, uint _Settlement_price) public {
        Compensation = _Compensation;
        Creditor=_Creditor;
        witness=_witness;
        publish_time=now;
        Settlement_price=_Settlement_price;
        memNum = 1;
        TermsNum = 1;
        Compensation_check = 0;
        Creditor_check = 0;
        witness_check = 0;
        check = 0;
    }

    function register(address _mem_address)public payable{
        for (uint i=1; i <= memNum ;i++){
            if(membership[i].mem_address == msg.sender ){
                check = 1;
            }
        }
        if(check == 0){
            membership[memNum] = mems({
                mem_address : _mem_address,
                publish_time : now
            });
            memNum ++;
        }
        check = 0;
    }

    function Fill_in_Compensation(address _Compensatio_address)public payable isCompensation{
        Compensation=_Compensatio_address;
        for (uint i=1; i <= memNum ;i++){
            if(membership[i].mem_address == msg.sender ){
                check = 1;
            }
        }
        if(check == 0){
            membership[memNum] = mems({
                mem_address : _Compensatio_address,
                publish_time : now
            });
            memNum ++;
        }
        check = 0;
    }
    
    function Fill_in_Creditor(address _Creditor_address)public payable isCreditor{
        Creditor=_Creditor_address;
        for (uint i=1; i <= memNum ;i++){
            if(membership[i].mem_address == msg.sender ){
                check = 1;
            }
        }
        if(check == 0){
            membership[memNum] = mems({
                mem_address : _Creditor_address,
                publish_time : now
            });
            memNum ++;
        }
        check = 0;
    }
    
    function Fill_in_witness(address _witness_address)public payable iswitness{
        witness=_witness_address;
        for (uint i=1; i <= memNum ;i++){
            if(membership[i].mem_address == msg.sender ){
                check = 1;
            }
        }
        if(check == 0){
            membership[memNum] = mems({
                mem_address : _witness_address,
                publish_time : now
            });
            memNum ++;
        }
        check = 0;
    }

    function payment() public payable isCompensation{
        Settlement_price = Settlement_price+msg.value;
    }
    
    function Certification() public onlyMember{
        for (uint i=1; i <= memNum ;i++){
            if(membership[i].mem_address == msg.sender){
                if(membership[i].mem_address == Compensation)
                    Compensation_check = 1;
                if(membership[i].mem_address == Creditor)
                    Creditor_check = 1;
                if(membership[i].mem_address == witness)
                    witness_check = 1;
            }
        }
    }
    
    function Archive() public allcheck{
        Termship[TermsNum] = Terms({
        Compensationa : Compensation,
        Creditora :Creditor,
        witnessa :witness,
        publish_time : now,
        price : Settlement_price
        });
        TermsNum++;
        Compensation_check = 0;
        Creditor_check = 0;
        witness_check = 0;
        make_payable(Creditor).transfer(address(this).balance);
    }

    
    function make_payable(address x) internal pure returns(address payable){
        return address(uint160(x));
    }

}