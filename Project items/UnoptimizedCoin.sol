// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract UnoptimizedCoin {
    mapping(address => uint256) internal _balances;

    mapping(address => mapping(address => uint256)) internal _allowances;

    uint256 internal _totalSupply;

    string internal _name;
    string internal _symbol;
    uint256 internal _decimals = 18;
    bool internal _isTransfer;
    bool internal _isTransferFrom;
    bool internal _isApprove;
    bool internal _iscurrentAllowanceGreater;
    bool internal _isAccountZero;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function getName() public view returns (string memory) {
        return _name;
    }

    function setName(string memory name_) public {
        _name = name_;
        restore();
    }

    function getSymbol() public view returns (string memory) {
        return _symbol;
    }

    function setSymbol(string memory symbol_) public {
        _symbol = symbol_;
        restore();
    }

    function decimals() public view returns (uint256) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function mint(address account, uint256 amount) public {
        _isAccountZero = account != address(0);
        require(_isAccountZero, "ERC20: mint to the zero address");

        _totalSupply += amount;
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            _balances[account] += amount;
        }
        restore();
    }

    function _msgSender() internal view returns (address) {
        return msg.sender;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        _isTransfer = true;
        return _isTransfer;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        _isTransferFrom = true;
        return _isTransferFrom;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        _isApprove = true;
        bool isApprove = _isApprove;
        restore();
        return isApprove;
    }

    function allowance(address owner, address spender)
        public
        view
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(
                iscurrentAllowanceGreater(owner, spender, amount),
                "ERC20: insufficient allowance"
            );
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    function iscurrentAllowanceGreater(
        address owner,
        address spender,
        uint256 amount
    ) internal returns (bool) {
        uint256 currentAllowance = allowance(owner, spender);
        _iscurrentAllowanceGreater = currentAllowance >= amount;
        return _iscurrentAllowanceGreater;
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        bool ownerAddress = owner != address(0);
        bool spenderAddress = spender != address(0);
        require(ownerAddress, "ERC20: approve from the zero address");
        require(spenderAddress, "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        bool isFromZero = from != address(0);
        bool isToZero = to != address(0);
        require(isFromZero, "ERC20: transfer from the zero address");
        require(isToZero, "ERC20: transfer to the zero address");

        uint256 fromBalance = _balances[from];
        bool isFromBalaceGreater = fromBalance >= amount;
        require(isFromBalaceGreater, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            _balances[to] += amount;
        }
    }

    function restore() internal {
        _isTransfer = false;
        _isTransferFrom = false;
        _isApprove = false;
        _iscurrentAllowanceGreater = false;
        _isAccountZero = false;
    }
}
