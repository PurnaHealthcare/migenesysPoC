import type { DomainEvent } from '../events/domain_events.js';
export interface Command {
    type: string;
    userId: string;
    data: any;
}
export declare class CommandHandler {
    private eventStore;
    handle(command: Command): Promise<DomainEvent>;
    private handleStartJourney;
    getEvents(): DomainEvent[];
}
//# sourceMappingURL=command_handler.d.ts.map