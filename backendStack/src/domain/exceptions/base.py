class DomainException(Exception):
    """Base domain exception"""

    pass


class EntityNotFound(DomainException):
    """Exception raised when entity is not found"""

    def __init__(self, entity_name: str, entity_id: str):
        self.entity_name = entity_name
        self.entity_id = entity_id
        super().__init__(f"{entity_name} with id {entity_id} not found")


class ValidationError(DomainException):
    """Exception raised when validation fails"""

    def __init__(self, message: str):
        super().__init__(message)


class ConflictError(DomainException):
    """Exception raised when a conflict occurs"""

    def __init__(self, message: str):
        super().__init__(message)
