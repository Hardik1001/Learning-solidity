//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 < 0.9.9;

contract Election{
    
    struct Candidate{
        string name; //Normally it is not a good practice to use string in a smart contract bcoz it takes more gas and thus makes our contract inefficient and unfeasible
        uint voteCount;//we will use an index here in place of name and map it to the name of Candidate on our front end when we make dapp.
    }
    
    struct Voter{
        uint weight;
        bool voteStatus;
        uint votedFor;
    }
    
    uint public startTime;
    enum Stages{init,reg,vote,end}
    Stages public stage = Stages.init;
    
    address public chairperson;
    mapping(address => Voter) addMapVoter;
    Candidate[] candidates;
    
    event votingCompleted();
    event winnerCalculated(uint index, uint totalVotes, string name);
    
    modifier onlyBy(address account){
        require(msg.sender==account,"wrong account");
        _;
    }
    
    modifier validStage(Stages requiredStage){
        require(stage==requiredStage,"invalid stage");
        _;
    }
    
    constructor(string[] memory candidateNames) onlyBy(msg.sender){
        chairperson=msg.sender;
        addMapVoter[chairperson].weight=1;
        for(uint i=0; i<candidateNames.length; i++){
            candidates.push( Candidate( {name:candidateNames[i], voteCount:0} ) );
        }
        stage=Stages.reg;
        startTime=block.timestamp;
    }
    
    function register(address _voter) public onlyBy(chairperson) validStage(Stages.reg){
        require(addMapVoter[_voter].weight==0,"already registered");
        addMapVoter[_voter].weight=1;
        addMapVoter[_voter].voteStatus=false;
        if(block.timestamp>startTime+10 seconds){
            stage=Stages.vote;
            startTime=block.timestamp;
        }
    }
    
    function vote(uint candidateIndex) public validStage(Stages.vote){
        Voter storage sender = addMapVoter[msg.sender];
        require(!sender.voteStatus || candidateIndex<candidates.length,"already voted or wrong candidateIndex input");
        sender.voteStatus=true;
        sender.votedFor=candidateIndex;
        candidates[candidateIndex].voteCount += sender.weight;
        if(block.timestamp>startTime+10 seconds){
            stage=Stages.end;
            emit votingCompleted();
        }
    }
    
    function winningCandidate() public view onlyBy(chairperson) validStage(Stages.end) returns(uint winnerindex, uint winningVoteCount, string memory winnerName){
        uint top=0;
        uint winnerIndex;
        for(uint i=0; i<candidates.length; i++){
            if(candidates[i].voteCount>top){
                top=candidates[i].voteCount;
                winnerIndex=i;
            }
        }
        assert(candidates[winnerIndex].voteCount>0);
        //emit winnerCalculated(winnerIndex,top,candidates[winnerIndex].name);
        return (winnerIndex,top,candidates[winnerIndex].name);
    }
}